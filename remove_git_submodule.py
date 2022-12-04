#!python
"""Remove a git submodule from a repository.

I have to look this up every time! This will remove a git submodule from a repository.

These instructions (for "modern git" as of 2022) are adapted from
https://stackoverflow.com/a/1260982/119527

This will only work on Windows.

This removes EVERYTHING. The references, the information, and the submodule itself.
Be careful where you run this from. You will lose uncommitted changes. I wrote this
to quickly remove multiple submodules (plugins) from my vimfiles repository.

Usage:

    This is a script that can be run from the command line.
    >>> remove_git_submodule.py path_to_a_submodule path_to_another_submodule

    It is also a module that can be imported and used in other scripts.
    >>> from remove_git_submodule import remove_git_submodule
    >>> remove_git_submodule("path_to_a_submodule", "path_to_another_submodule")

But don't do that. By the time you find this, the procedure will have changed. I made
this public for example purposes.

:author: Shay Hill
"""
import argparse
import os
import shutil
import stat
import subprocess
from typing import Any, Callable

_cwd = os.getcwd()


def _remove_readonly(func: Callable[[str], Any], path: str, _: Any):
    """Clear the readonly bit and reattempt the removal.

    Copied directly from shutil docs. This is needed because git creates read-only
    files, and rmtree will not delete them until they are made writable.
    """
    os.chmod(path, stat.S_IWRITE)
    func(path)


def remove_git_submodule(*path_args: str, root: str = _cwd):
    """Remove the submodule.

    :param path: optional path or paths to a submodule to remove. Will check here and
        sys.argv for submodule paths.
    :param root: optionally specify a root directory to search for submodules. If not
        given, will use the current working directory. This may be necessary if you
        are calling this script from another directory.

    """
    for path in (os.path.relpath(x, root) for x in path_args):
        posix = path.replace("\\", "/")
        _ = subprocess.run(["git", "rm", "-f", path])
        _ = subprocess.run(["git", "config", "--remove-section", f"submodule.{posix}"])
        folder_in_git_modules = os.path.join(".git", "modules", path)
        try:
            shutil.rmtree(folder_in_git_modules, onerror=_remove_readonly)
        except FileNotFoundError:
            # simplify the mess of nested exception messages by just saying "not found"
            print(f"{folder_in_git_modules} not found.")

        # If everything was healthy before running this, the submodule will be gone.
        # But there are a lot of ways to trip up git submodules, so, just in case,
        # delete the folder if it still exists. If you're still getting "exists in
        # index" or similar errors when trying to re-add a removed submodule, try
        # committing before attempting to re-add.
        try:
            shutil.rmtree(posix)
        except FileNotFoundError:
            # nothing to worry about, was removed in a previous step
            pass


def _get_parser() -> argparse.ArgumentParser:
    """Return an argument parser for this script."""
    parser = argparse.ArgumentParser(
        description="Remove a git submodule from a repository.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    _ = parser.add_argument(
        "submodule",
        nargs="*",
        help="path (relative to project root) or space-delimited paths to "
        + "submodule(s) to remove.",
    )
    _ = parser.add_argument(
        "-r",
        "--root",
        help="directory to search for submodules. If not given, will use the current "
        + "working directory. This argument may be necessary if you are calling this "
        + "script from another directory. This will be the root of the git repo.",
    )
    return parser


if __name__ == "__main__":
    parser = _get_parser()
    args = parser.parse_args()
    if hasattr(args, "submodule"):
        submodules = getattr(args, "submodule")
        remove_git_submodule(*submodules, root=args.root)
    _ = os.system("pause")
