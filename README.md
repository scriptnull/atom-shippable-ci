# Shippable CI
[Shippable](https://shippable.com) integration within atom.

### Features
- Get current status of the build.
- Shortcuts for navigating to Shippable web interface.

> All features are available for both public and private projects.

### Set up
Add project details in `shippable.yml` file.

```yml
atom:
  projectId: 12345678910
```
You can find your project's id in the url of your project page.
![projectId](https://raw.githubusercontent.com/scriptnull/atom-shippable-ci/master/images/shippable_projectId.png)

If you want to set up private projects, you need to paste your `apiToken` in the settings page (`ctrl+,`) of the package.

### Commands
Press `Ctrl+Shift+P` to access command palette and search for Shippable.
You can activate all the shippable commands via command palette or through key bindings.

#### Current Status
> Keymap : Shift+S S

Check the current status of the latest build of a project.

![currentStatus](https://raw.githubusercontent.com/scriptnull/atom-shippable-ci/master/images/shippable_current_status.gif)

#### Open Project in Browser
> keymap : Shift+S P

Opens project page of the current project in web browser.

![openProject](https://raw.githubusercontent.com/scriptnull/atom-shippable-ci/master/images/shippable_open_project.gif)

#### Open Latest Build in Browser
> keymap : Shift+S B

Opens latest build of the current project in web browser.

![openBuild](https://raw.githubusercontent.com/scriptnull/atom-shippable-ci/master/images/shippable_open_build.gif)
