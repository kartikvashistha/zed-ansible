# zed-ansible
A WIP Ansible LSP Extension for the Zed editor.

## Observations
In it's current state, the language server gets started and performs decently well. Since the ansible language server runs `ansible-lint` after saving a file, make sure its installed and on the PATH.

Strangely, the language server appears to crash when the completion list returned from the LSP is quite large, and only a restart of the workspace fixes it. For the time being, I'm unable to determine how this can be fixed.

If completions from the community or any other collection dont appear, create an `ansible.cfg` file in your project and add the path of your collection.

### Detecting your Ansible files
Currently, it appears that we might not be able to fully use glob patterns with file extensions containing two dots in `path_suffixes` under `languages/ansible/config.toml` (related issue [here](https://github.com/zed-industries/zed/issues/10997)).

The workaround for this is to add something like th9s following under Zed's global settings to correctly assign the `Ansible` filetype to your relevant ansible files:
```
"file_types": {
    "Ansible": [
      "**.ansible.yml",
      "**/defaults/**.yml",
      "**/tasks/**.yml",
      "**/tasks/*.yml",
      "**/tasks/*.yaml",
      "**/handlers/*.yml",
      "**/handlers/*.yaml",
      "**playbook*.yaml",
      "**playbook*.yml"
    ]
  },
```
Feel free to modify this list as per your needs.

### LSP settings
I haven't been able to understand how to pass additional options to this language server. I have tried something like the following under Zed's settings to disable linting and break python for testing purposes, but it doesn't seem to work:
```
"lsp": {
  "ansible-language-server": {
    "ansible": {
      "python": {
        "interpreterPath": "python34349340"
      },
      // ansible = {
      //   path = 'ansible',
      // },
      "executionEnvironment": {
        "enabled": false
      },
      "validation": {
        "enabled": false,
        "lint": {
          "enabled": false
          // "path": "ansible-lint"
        }
      }
    }
  },
  "initialization_options": {
    "python": {
      "interpreterPath": "python34349340"
    },
    // ansible = {
    //   path = 'ansible',
    // },
    "executionEnvironment": {
      "enabled": false
    },
    "validation": {
      "enabled": false,
      "lint": {
        "enabled": false
        // "path": "ansible-lint"
      }
    }
  }
```

### Highlighting
Currently, this implementaion uses YAML for syntax highlighting. Note, I haven't been able to get the Ansible LSP's additional highlighting working alongisde this.
