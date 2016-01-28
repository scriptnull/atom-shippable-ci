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
![packageSettings](https://raw.githubusercontent.com/scriptnull/atom-shippable-ci/master/images/shippable_settings.png)
