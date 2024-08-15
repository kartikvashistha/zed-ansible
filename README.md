# zed-ansible
A WIP Ansible LSP Extension for the Zed editor.

## Recomended Settings
For the best experience, it is recommended to add the following configuration under Zed's global settings:

### Filetypes

By default, the Ansible LSP attaches to all files ending with `.ansible`.

It appears that we might not be able to configure the LSP to fully use glob patterns within this extension to detect ansible files under common directories (related issue [here](https://github.com/zed-industries/zed/issues/10997)) - as such, for the time being, it's reccomended to configure this in `file_types` under Zed's settings.

The workaround for this is to add something like the following under Zed's settings to correctly assign the `Ansible` filetype to your relevant ansible files:
```json
...
"file_types": {
    "Ansible": [
      "**.ansible.yml",
      "**/defaults/**.yml",
      "**/defaults/**.yaml",
      "**/meta/**.yml",
      "**/meta/**.yaml",
      "**/tasks/**.yml",
      "**/tasks/*.yml",
      "**/tasks/*.yaml",
      "**/handlers/*.yml",
      "**/handlers/*.yaml",
      "**/group_vars/**.yml",
      "**/group_vars/**.yaml",
      "**playbook*.yaml",
      "**playbook*.yml"
    ]
  }
```
Feel free to modify this list as per your needs.

### LSP Configuration
To get the best experience, add the following configuration under lsp settings:
```json
"lsp": {
  "ansible-language-server": {
    "settings": {
      "ansible": {
        "path": "ansible"
      },
      "executionEnvironment": {
        "enabled": false
      },
      "python": {
        "interpreterPath": "python3"
      },
      "validation": {
        "enabled": true,
        "lint": {
          "enabled": true,
          "path": "ansible-lint"
        }
      }
    }
  }
}
```
This config was conveniently adopted from [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig/blob/ad32182cc4a03c8826a64e9ced68046c575fdb7d/lua/lspconfig/server_configurations/ansiblels.lua#L6-L23). Note how the first `ansible` key from the settings can be omitted as it's added from within the extension code - this is to allow for a cleaner config under Zed's config file.

A full list of options/settings, that can be passed to the server, can be found at the project's page here: https://github.com/ansible/vscode-ansible/blob/5a89836d66d470fb9d20e7ea8aa2af96f12f61fb/docs/als/settings.md


## Notes
In it's current state, the language server gets started and performs decently well. Since the ansible language server runs `ansible-lint` after saving a file, make sure its installed and on the PATH.

Sometimes, the language server may crash when the completion list returned from the LSP is quite large, and only a restart of the workspace fixes it. For the time being, I'm unable to determine how this can be fixed - I think it happens when `executionEnvironment` is not explicity set, but I'm not clear about this.

If completions from the community or any other collection dont appear, create an `ansible.cfg` file in your project and add the path of your collection in there.

### Highlighting
Currently, this implementaion uses YAML for syntax highlighting. Note, I haven't been able to get the Ansible LSP's additional highlighting working alongisde this (or at least unable to determine if it's working at all).
