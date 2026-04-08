# zed-ansible

Community maintained Ansible extension for the Zed editor.

## Pre-requisites

Ensure python3, ansible and ansible-lint are installed via your system's package manager:

```shell
# For macos, when using the homebrew package manager
brew install ansible ansible-lint

# For Fedora based systems
sudo dnf install ansible python3-ansible-lint

# For Ubuntu based systems
sudo apt install ansible ansible-lint python3
```

## Recommended Settings

For the best experience, add the following configuration(s) as needed under Zed's global settings:

### Filetype detection

By default, the Ansible LSP attaches to all files ending with `.ansible` due to [this](https://github.com/zed-industries/zed/issues/10997).

Currently, it is not possible to use glob patterns within this extension's code to detect Ansible files under common directory patterns - as such, for the time being, it is recommended to configure the file detection under `file_types` under Zed's settings:

```jsonc
...
"file_types": {
    "Ansible": [
      "**.ansible.yml",
      "**.ansible.yaml",
      "**/defaults/*.yml",
      "**/defaults/*.yaml",
      "**/meta/*.yml",
      "**/meta/*.yaml",
      "**/tasks/*.yml",
      "**/tasks/*.yaml",
      "**/handlers/*.yml",
      "**/handlers/*.yaml",
      "**/group_vars/*.yml",
      "**/group_vars/*.yaml",
      "**/playbooks/*.yaml",
      "**/playbooks/*.yml",
      "**playbook*.yaml",
      "**playbook*.yml"
    ]
  }
```

Feel free to modify this list as per your needs.

If your inventory file is in the YAML format, you can either:

- Append the `ansible-lint` inventory json schema to it via the following comment at the top of the file ([example](example/hosts.yml)):

```yml
# yaml-language-server: $schema=https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/inventory.json
```

- Or configure setting this schema under `lsp.yaml-language-server` under Zed's settings for your inventory pattern ([ref](https://zed.dev/docs/languages/yaml)):

```jsonc
"lsp": {
    "yaml-language-server": {
      "settings": {
        "yaml": {
          "schemas": {
            "https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/inventory.json": [
              "./inventory/*.yaml",
              "hosts.yml",
            ]
          }
        }
      }
    }
},
```

### LSP Configuration

By default, the following config is passed to the Ansible language server:

```jsonc
{
  "ansible": {
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
```

When desired, the above default settings can be overridden via Zed's `settings.json` configuration file under the `lsp` key:

```jsonc
...
"lsp": {
  "ansible-language-server": {
    "settings": {
      // Note: the Zed Ansible extension prefixes all settings with the `ansible` key to provide for a cleaner config under here.
      // So instead of using `ansible.ansible.path` use `ansible.path`and so on.
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
        "enabled": false, //disable validation
        "lint": {
          "enabled": false, //disable ansible-lint
          "path": "ansible-lint"
        }
      }
    }
  }
}
```

This config conveniently mirrors [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig/blob/ad32182cc4a03c8826a64e9ced68046c575fdb7d/lua/lspconfig/server_configurations/ansiblels.lua#L6-L23)'s defaults for Ansible language server.
A full list of options/settings, that can be passed to the server, can be found [here](https://github.com/ansible/vscode-ansible/blob/5a89836d66d470fb9d20e7ea8aa2af96f12f61fb/docs/als/settings.md).

#### Using with uv-managed virtual environments

If you use [uv](https://docs.astral.sh/uv/) to manage your project's virtual environment, point the language server to the `.venv` Python interpreter and ansible-lint:

```jsonc
"lsp": {
  "ansible-language-server": {
    "settings": {
      "python": {
        "interpreterPath": ".venv/bin/python"
      },
      "validation": {
        "lint": {
          "path": ".venv/bin/ansible-lint"
        }
      }
    }
  }
}
```

### Highlighting

This extension uses YAML for base syntax highlighting. For enhanced highlighting of Ansible keywords, module names, and parameters, enable [semantic tokens](https://zed.dev/docs/semantic-tokens) in your Zed settings:

```jsonc
"languages": {
  "Ansible": {
    "semantic_tokens": "combined"
  }
}
```

This leverages the Ansible language server to distinguish:

- **Module names** (e.g., `ansible.builtin.copy`)
- **Module parameters** (e.g., `src`, `dest`)
- **Ansible keywords** (`when`, `become`, `register`, `tasks`, etc.)

> [!NOTE]
> Full Jinja2 expression highlighting within Ansible files is not yet available.

## Notes

In it's current state, the language server gets started and performs decently well.
Sometimes, the language server may _crash_ either when the completion list returned from the LSP is quite large or when switching between multiple Ansible files. For the time being, I'm unable to determine how this can be fixed permanently.

To restart the language server, open the Command Palette and execute `editor: Restart Language Server`.

If completions from the community or any other collection dont appear, create an `ansible.cfg` file in your project and add the path of your collection in there.
