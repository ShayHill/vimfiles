#!python
"""Add or remove all vim plugins

Sync plugins with plugins.txt. Remove any plugins not in plugins.txt, and add any
plugins in plugins.txt that are not installed.

Usage:
    install_all_packages.py [--replace-all]

    --replace-all: Remove all plugins, even if they are requested in plugins.txt,
    then add contents in plugins.txt

:author: Shay Hill
"""
import argparse
import os
import re
import subprocess
from dataclasses import dataclass, field
from pathlib import Path
from typing import Optional

from remove_git_submodule import remove_git_submodule

_DEFAULT_PLUGIN_DIR = Path("pack", "plugins", "start")
_PLUGINS_FILENAME = "plugins.txt"

# identify `# ... pack/*/*` in plugins.txt
_PLUGIN_DIR_RE = re.compile(r"^#.*\s(pack/[^/]+/\w+)$")

# identify `user/repo` in plugins.txt
_PLUGIN_NAME_RE = re.compile(r"(?P<user>[^/]+)/(?P<repo>[^/]+)")


@dataclass
class _Plugin:
    """Information required to find a plugin repo on github or local disc.

    :param user: github user or organization -> github.com/user/repo
    :param repo: github repo -> github.com/user/repo
    :param plugin_dir: path to local plugin directory -> e.g., pack/plugins/start/
    """

    user: str
    repo: str
    _local_dir: Path = field(init=True, repr=False, compare=False)
    local_path: Path = field(init=False)

    def __post_init__(self):
        """Build local path from input values"""
        self.local_path = self._local_dir / self.repo

    @property
    def url(self):
        """Github url for this plugin"""
        return f"https://github.com/{self.user}/{self.repo}"


def _read_plugins_file() -> list[str]:
    """Read the plugins file and return a list of lines."""
    with open(_PLUGINS_FILENAME, "r", encoding="utf-8") as f:
        return f.readlines()


def _get_installed_plugin_paths() -> set[Path]:
    """List all installed plugin names"""
    return set(Path("pack").glob("*/*/*"))


def _get_requested_plugins() -> list[_Plugin]:
    """Read the plugins file and return a list of plugins."""
    plugin_dir: Optional[Path] = None
    plugins: list[_Plugin] = []
    for line in _read_plugins_file():
        line = line.strip()
        if match := _PLUGIN_DIR_RE.match(line):
            plugin_dir = Path(match.group(1))
            continue
        if not line or plugin_dir is None or line.startswith('"'):
            continue
        if match := _PLUGIN_NAME_RE.match(line):
            user = match["user"]
            repo = match["repo"]
            assert plugin_dir is not None
            plugins.append(_Plugin(user, repo, plugin_dir))
            continue
        raise ValueError(f"Could not parse instruction {line} in {_PLUGINS_FILENAME}")
    return plugins


def _install_plugin(plugin: _Plugin) -> None:
    """Run the command to add a submodule to the plugin_dir."""
    _ = subprocess.run(["git", "submodule", "add", plugin.url, plugin.local_path])


def sync_plugins(replace_all: bool = False) -> None:
    """Sync plugins with plugins.txt

    :param replace_all: if True, remove all plugins and replace with contents in
        plugins.txt
    """
    requested = _get_requested_plugins()
    installed_paths = _get_installed_plugin_paths()
    requested_paths = {p.local_path for p in requested}
    to_remove = set(installed_paths)
    to_install = set(requested_paths)
    if not replace_all:
        to_remove -= requested_paths
        to_install -= installed_paths
    for local_path in to_remove:
        remove_git_submodule(str(local_path))
    for local_path in to_install:
        plugin = next(p for p in requested if p.local_path == local_path)
        _install_plugin(plugin)
    if not any([to_remove, to_install]):
        print("No changes required to plugins")
    else:
        print("Plugins synced")


def _get_parser() -> argparse.ArgumentParser:
    """Return an argument parser for this script."""
    parser = argparse.ArgumentParser(
        description="Sync plugins with plugins.txt",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    _ = parser.add_argument(
        "--replace-all",
        action="store_true",
        help="Remove all plugins and replace with contents in plugins.txt",
    )
    return parser


if __name__ == "__main__":
    parser = _get_parser()
    args = parser.parse_args()
    sync_plugins(args.replace_all)
    _ = os.system("pause")
