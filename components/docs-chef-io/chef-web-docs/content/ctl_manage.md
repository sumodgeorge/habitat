+++
title = "chef-manage-ctl (executable)"
draft = false
robots = "noindex"


aliases = ["/ctl_manage.html"]

[menu]
  [menu.infra]
    title = "chef-manage-ctl"
    identifier = "chef_infra/features/management_console/ctl_manage.md chef-manage-ctl"
    parent = "chef_infra/features/management_console"
    weight = 110
+++

[\[edit on GitHub\]](https://github.com/chef/chef-web-docs/blob/master/content/ctl_manage.md)

{{% chef_automate_mark %}}

{{% EOL_manage %}}

{{% EOL_a1 %}}

The Chef management console includes a command-line utility named
`chef-manage-ctl`. This command-line tool is used to reconfigure,
cleanse (reset the Chef management console to initial configuration
settings), and uninstall the Chef management console.

## cleanse

The `cleanse` subcommand is used to re-set the Chef management console
to the state it was in prior to the first time the `reconfigure`
subcommand is run. This command will destroy all data, configuration
files, and logs. The software that was put on-disk by the package
installation will remain; re-run `chef-manage-ctl reconfigure` to
recreate the default data and configuration files.

This subcommand has the following syntax:

``` bash
chef-manage-ctl cleanse
```

## help

The `help` subcommand is used to print a list of all available
`chef-manage-ctl` commands.

This subcommand has the following syntax:

``` bash
chef-manage-ctl help
```

## reconfigure

The `reconfigure` subcommand is used when changes are made to the
manage.rb file to reconfigure the server. When changes are made to the
manage.rb file, they will not be applied to the Chef management console
configuration until after this command is run.

This subcommand has the following syntax:

``` bash
chef-manage-ctl reconfigure
```

## show-config

The `show-config` subcommand is used to view the configuration that will
be generated by the `reconfigure` subcommand. This command is most
useful in the early stages of a deployment to ensure that everything is
built properly prior to installation.

This subcommand has the following syntax:

``` bash
chef-manage-ctl show-config
```

## uninstall

The `uninstall` subcommand is used to manage the hooks between runit and
`sysvinit` or `upstart`. This subcommand does not [uninstall the Chef
management console](/uninstall/#chef-manage) or remove `.rpm` or
`.deb` files.

This subcommand has the following syntax:

``` bash
chef-manage-ctl uninstall
```