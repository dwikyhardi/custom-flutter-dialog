import os
from pathlib import Path
import subprocess
import tempfile
import textwrap
import unittest


WORKFLOWS = Path(__file__).resolve().parents[1] / 'workflows'


def first_script(workflow):
    text = (WORKFLOWS / workflow).read_text().split('        run: |\n', 1)[1]
    return textwrap.dedent(text.split('\n      - ', 1)[0])


class ReleaseGuardsTest(unittest.TestCase):
    def run_script(self, workflow, **overrides):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / 'pubspec.yaml').write_text(
                f'version: {overrides.pop("VERSION", "2.0.0")}\n'
            )
            mocks = {
                'curl': 'printf "%s" "${PUB_STATUS:-404}"',
                'git': '''case "$1" in
                    merge-base) exit "${ANCESTRY_EXIT:-0}" ;;
                    show-ref) exit "${TAG_LOOKUP_EXIT:-1}" ;;
                    rev-list) echo "${TAG_SHA:-tested}" ;;
                    rev-parse) echo tested ;;
                    *) exit 99 ;;
                esac''',
            }
            for name, script in mocks.items():
                executable = root / name
                executable.write_text('#!/bin/bash\n' + script + '\n')
                executable.chmod(0o755)
            output = root / 'output'
            env = {
                **os.environ,
                'PATH': f'{root}:{os.environ["PATH"]}',
                'GITHUB_OUTPUT': str(output),
                'RELEASE_TAG': 'd_dialog-v2.0.0',
                **overrides,
            }
            result = subprocess.run(
                ['bash', '-c', first_script(workflow)],
                cwd=root, env=env, capture_output=True, text=True,
            )
            return result.returncode, output.read_text() if output.exists() else ''

    def test_auto_tag_guards(self):
        cases = [
            ({}, True, True),
            ({'PUB_STATUS': '200'}, True, False),
            ({'PUB_STATUS': '503'}, False, False),
            ({'VERSION': 'invalid'}, False, False),
            ({'ANCESTRY_EXIT': '1'}, False, False),
            ({'TAG_LOOKUP_EXIT': '0'}, True, False),
            ({'TAG_LOOKUP_EXIT': '0', 'TAG_SHA': 'different'}, False, False),
        ]
        for env, success, release in cases:
            with self.subTest(env=env):
                code, output = self.run_script('auto-tag.yml', **env)
                self.assertEqual(code == 0, success)
                self.assertEqual('release=true\n' in output, release)
                if release:
                    self.assertIn('tag=d_dialog-v2.0.0\n', output)

    def test_publish_guards(self):
        for env, success in [
            ({}, True),
            ({'RELEASE_TAG': 'd_dialog-v1.0.2'}, False),
            ({'ANCESTRY_EXIT': '1'}, False),
        ]:
            with self.subTest(env=env):
                code, _ = self.run_script('publish.yml', **env)
                self.assertEqual(code == 0, success)


if __name__ == '__main__':
    unittest.main()
