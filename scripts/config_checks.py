"""Check that all plugins get loaded, that config is valid, etc.

:author: Shay Hill
:created: 2026-09-06
"""

from pathlib import Path
from collections.abc import Iterator

VIMDIR = Path(__file__).parents[1]
VIMRC = VIMDIR / "vimrc"

PACK_OPT = VIMDIR / "pack" / "minpac" / "opt"
PACK_START = VIMDIR / "pack" / "minpac" / "start"


# files in which to look for packadd commands
_FIND_PACKADD = [
    VIMRC,
    *(VIMDIR / "after" / "plugin").iterdir(),
    *(VIMDIR / "ftplugin").iterdir(),
    *(VIMDIR / "after" / "ftplugin").iterdir(),
]

# ===================================================================================
#   Print a report of where plugins are loaded.
# ===================================================================================


def _iter_opt_plugins() -> Iterator[Path]:
    """Iterate over all optional plugins."""
    return (x for x in PACK_OPT.iterdir() if x.is_dir())


def _has_packadd(plugin_name: str, path: Path) -> bool:
    """Return True if `packadd {plugin_name}` is found in vimrc or any ftplugin."""
    with path.open(encoding="utf-8") as f:
        content = f.read()
    if content.find(f"packadd {plugin_name}") != -1:
        return True
    return content.find(f"packadd! {plugin_name}") != -1


def _find_where_plugin_loaded(plugin_name: str) -> list[Path]:
    """Find `packadd {plugin_name}` in vimrc or any ftplugin."""
    return [x for x in _FIND_PACKADD if _has_packadd(plugin_name, x)]


def _print_opt_plugins_loaded() -> None:
    """Print a report of where optional plugins are loaded."""
    for plugin in _iter_opt_plugins():
        loaded_in = _find_where_plugin_loaded(plugin.name)
        if not loaded_in:
            print(f"WARNING: Optional plugin {plugin.name} is not loaded anywhere.")
            continue
        if loaded_in == [VIMRC]:
            continue
        print(f"Optional plugin {plugin.name} is loaded in:")
        for file in loaded_in:
            print(f"  {file.relative_to(VIMDIR)}")


# ===================================================================================
#   Check ultisnips loaded for any filetype with snippets
# ===================================================================================


def _iter_snippet_files() -> Iterator[Path]:
    """Yield all filetypes with snippets defined."""
    return (VIMDIR / "ultisnips").iterdir()


ULTISNIPS_LOADED = _find_where_plugin_loaded("ultisnips")


def _print_where_ultisnips_loaded(ft: str) -> None:
    """Check that any filetype with snippets loads ultisnips."""
    ft_loaded = [x for x in ULTISNIPS_LOADED if x.name == f"{ft}.vim"]
    if not ft_loaded:
        print(f"snippets available for {ft}, but ultisnips not loaded in ftplugin")
        return
    for path in ft_loaded:
        print(f"Ultisnips {ft}")
        print("    " + str(path.relative_to(VIMDIR)))


if __name__ == "__main__":
    _print_opt_plugins_loaded()
    for has_snippets in _iter_snippet_files():
        _print_where_ultisnips_loaded(has_snippets.stem)
