+++
title = "Integrate Workflow with GitHub"
draft = false
robots = "noindex"


aliases = ["/integrate_delivery_github.html", "/release/automate/integrate_delivery_github.html"]

[menu]
  [menu.legacy]
    title = "Workflow w/GitHub"
    identifier = "legacy/workflow/managing_workflow/integrate_delivery_github.md Workflow w/GitHub"
    parent = "legacy/workflow/managing_workflow"
    weight = 90
+++

[\[edit on GitHub\]](https://github.com/chef/chef-web-docs/blob/master/content/integrate_delivery_github.md)

{{% chef_automate_mark %}}

{{% EOL_a1 %}}

Workflow's GitHub integration allows you to use GitHub as the canonical
git repository for your projects while benefiting from Workflow's
workflow and pipeline automation. When you enable the integration on a
project in Workflow, you will be able to:

-   Review pull requests and make code comments in the GitHub UI.
-   Browse code (including in-flight changes in the Workflow pipeline)
    using GitHub.
-   Have the target branch (usually master) of your GitHub project
    repository managed by Workflow. When a change is approved in
    Workflow, it will perform the merge in GitHub.

Workflow's GitHub integration is designed for use with GitHub.com and
GitHub Enterprise 2.x, and supports connecting a Workflow enterprise
with a single GitHub server URL.

{{< note >}}

The Delivery CLI from the latest [Chef
Workstation](https://downloads.chef.io/chef-workstation/) must be
installed on any workstations that setup and initialize
GitHub-integrated projects.

{{< /note >}}

## Setting up integration with GitHub

To enable the GitHub integration, you will need:

1.  A Workflow user account with `admin` role in the Workflow enterprise
    you wish to connect.

2.  The URL for your GitHub instance.

3.  A GitHub user to use as the service account. This user must have
    full access (read/write) to the projects you wish to add to
    Workflow.

    ![image](/images/collaborator_permission.png)

4.  A Personal Access token generated by your GitHub service account.

To create a token, sign in to GitHub as your service account.

1.  Select **Settings** from the menu at the top right.

    ![image](/images/github_user_menu.png)

2.  Go to Developer settings and click **Personal access tokens**.

    ![image](/images/github_menu.png)

    ![image](/images/developers_menu.png)

3.  Click **Generate new token**.

    ![image](/images/personal_access_token.png)

4.  Fill in a description of the purpose of this token and select the
    checkboxes for the following permissions: `repo`, `public_repo`,
    `write:public_key`, and `admin:repo_hook`.

    ![image](/images/new_token.png)

5.  Click **Generate token**. The next screen will contain the token you
    need. Make sure to copy it before you leave this screen!

    ![image](/images/token_created.png)

### Trusting a Self-Signed SSL Certificate

This procedure is only needed when connecting to GitHub Enterprise, and
when your GitHub Enterprise server uses a self-signed SSL certificate.

{{< note >}}

Even when trusted, self-signed certificates only work when the
certificate subject is the same as the host running the service. For
example, if the certificate subject is an IP address such as
`10.10.10.10`, but the GitHub Enterprise server is reachable at <span
class="title-ref">github.example.com</span>, the URL
`https://github.example.com` will fail SSL certificate validation while
the URL `https://10.10.10.10` will pass.

{{< /note >}}

#### Debian

1.  Log into your Workflow Server as root.

2.  Change directory to `ca-certificates`.

    ``` bash
    cd /usr/local/share/ca-certificates
    ```

3.  Copy your certificate into the `/usr/local/share/ca-certificates`
    directory.

    ``` bash
    openssl s_client -showcerts -connect {your-GitHub-server}:443 </dev/null 2>/dev/null|openssl x509 -outform PEM >{your-GitHub-server}.crt
    ```

4.  Update the CA store on the Workflow server.

    ``` bash
    update-ca-certificates
    ```

#### Rhel/CentOS 6.x and greater

1.  Log into your Workflow Server as root.

2.  Install the `ca-certificates` package.

    ``` bash
    yum install ca-certificates
    ```

    {{< note spaces=4 >}}

    You only need to do this once for 6.x servers.

    {{< /note >}}

3.  Enable the dynamic CA configuration feature.

    ``` bash
    update-ca-trust force-enable
    ```

    {{< note spaces=4 >}}

    You only need to do this once for 6.x servers.

    {{< /note >}}

4.  Change directory to the `anchors` directory.

    ``` bash
    cd /etc/pki/ca-trust/source/anchors/
    ```

5.  Copy your certificate into the `/etc/pki/ca-trust/source/anchors/`
    directory.

    ``` bash
    openssl s_client -showcerts -connect {your-GitHub-server}:443 </dev/null 2>/dev/null|openssl x509 -outform PEM >{your-GitHub-server}.crt
    ```

6.  Create or update the generated CA certificate bundle files located
    in the `/etc/pki/ca-trust/extracted` directory hierarchy.

    ``` bash
    update-ca-trust extract
    ```

### Associating Workflow with your GitHub instance

1.  In Workflow's web UI, click the `Admin` button in the top
    navigation.
2.  From the left navigation, click `SCM Setup`.
3.  Click the `GitHub` tab.
4.  Fill out the following fields.
    -   `GitHub URL` - The URL for your GitHub instance.
    -   `GitHub Username` - The username of the service account that
        Workflow will use to interact with GitHub.
    -   `GitHub Token` - Token generated by the service account on
        GitHub.
5.  Submit the form.

## Updating the integration with GitHub

If you need to change the GitHub credentials, follow these steps:

1.  In Workflow's web UI, click the `Admin` button in the top
    navigation.
2.  From the left navigation, click `Scm Setup`.
3.  Click the `GitHub` tab.
4.  Correct the appropriate information.
5.  Click the `Update` button.

## Creating a new GitHub-integrated project

You can repeat these steps for each GitHub project you want to add to
Workflow.

To begin, you will need:

-   A project repository in GitHub with at least one commit.
-   A service account used by Workflow that has full access to your
    GitHub repository.
-   Your teams set up with read-only access to this repository. Workflow
    will manage creation of pull requests and merging of pull requests.

### Initializing a new GitHub project in Workflow

1.  Create a local clone of the project **from GitHub** and `cd` into
    it.

2.  Create a `.delivery/cli.toml` using `delivery setup`:

    ``` bash
    delivery setup --ent=$AUTOMATE_ENTERPRISE --org=$AUTOMATE_ORG --user=$AUTOMATE_USER_NAME --server=$AUTOMATE_SERVER
    ```

3.  If the desired default pipeline is *not* master, manually edit
    `.delivery/cli.toml` to reflect the desired pipeline.

4.  Start the initialization process by running:

    ``` bash
    delivery init --github $GITHUB_ORGANIZATION --repo-name $REPOSITORY_NAME
    ```

    By default, Workflow will use the current directory name as project
    name. If you want to name the project something else, you may
    specify the project name as an argument
    (`--project=$AUTOMATE_PROJECT_NAME`).

    After importing your code, this command generates a <span
    class="title-ref">.delivery/config.json</span> file, creates a build
    cookbook, and submits a change to Workflow that initializes a
    pipeline for the project. Your browser will open to the change in
    Workflow. At this point, you should be able to see a corresponding
    pull request in GitHub.

    {{< note spaces=4 >}}

    You may also specify a different pipeline than the default
    (`master`) by specifying the argument `--pipeline=$PIPELINE`;
    however, this will not update the `.delivery/cli.toml` file.

    {{< /note >}}

### Multiple pipelines

If multiple pipelines are desired:

1.  Push the desired branch to the Workflow server using
    `git push delivery $BRANCH_NAME`.
2.  Navigate to the project's page
    (`/$ENT_NAME/organizations/$ORG_NAME/projects/$PROJECT_NAME`) in the
    Workflow web UI and click the `Pipelines` tab.
3.  Click `Add A New Pipeline` on the top of the page.
4.  Give pipeline a descriptive name and input the base branch.

## Integrating an existing project with GitHub

You will need:

-   A project repository in GitHub with at least one commit.
-   A service account used by Workflow that has full access to your
    GitHub repository.
-   Your teams set up with read-only access to this repository. Workflow
    will manage creation of pull requests and merging of pull requests.

Do the following steps:

1.  In Workflow's web UI, click the `Workflow` button in the top
    navigation.
2.  Select `Workflow Orgs` from the left navigation.
3.  Click the organization you want to add a project to.
4.  Click the pencil button of the project you wish to update.
5.  Click the `GitHub` tab.
6.  Fill in the project key and repository name.
7.  Click `Save & Close`.

## Updating GitHub information for a project

1.  In Workflow's web UI, click the `Workflow` button in the top
    navigation.
2.  Select `Workflow Orgs` from the left navigation.
3.  Click the organization you want to add a project to.
4.  Click the pencil button of the project you wish to update.
5.  Click the `GitHub` tab.
6.  Update your project key and/or repo name with updated information.
7.  Click `Save & Close`.

## Removing GitHub integration from an existing project

1.  Merge or close all open changes for the project.
2.  In Workflow's web UI, click the `Workflow` button in the top
    navigation.
3.  Select `Workflow Orgs` from the left navigation.
4.  Click the organization you want to add a project to.
5.  Click the pencil button of the project you wish to update.
6.  Click the `Chef Delivery` tab.
7.  Click `Save & Close`.

## Removing GitHub integration from Workflow

1.  Remove GitHub integrations for existing projects.
2.  In Workflow's web UI, click the `Admin` button in the top
    navigation.
3.  From the left navigation, click `Scm Setup`.
4.  Click the `GitHub` tab.
5.  Click the `Remove Link` button.

## Workflow workflow with GitHub

This section describes the setup and workflow that a member of a team
would use to interact with a project using Workflow's GitHub
integration. Here we assume that the initial project creation, import,
and pipeline setup has already occurred.

### Configure your Delivery CLI and clone your project's code

1.  In your command shell, create or navigate to a directory where you
    will store project repositories. Use `delivery setup` with arguments
    as shown below to create a `.delivery/cli.toml` file:

    ``` bash
    delivery setup --ent=$AUTOMATE_ENTERPRISE --org=$AUTOMATE_ORG --user=$AUTOMATE_USER --server=$AUTOMATE_SERVER
    ```

2.  Create a local clone of the project repository.

    ``` bash
    delivery clone $PROJECT
    ```

    {{< note spaces=4 >}}

    If you clone from GitHub instead (or make use of a pre-existing
    clone), you will need to add a `delivery` remote. The Workflow clone
    URL can be found on the project's page in the Workflow UI. To create
    the remote, run the following:

    ``` bash
    git remote add delivery $AUTOMATE_CLONE_URL
    ```

    {{< /note >}}

### Creating a Change (Pull Request)

1.  Create and check out a topic branch for your change, based on the
    current state of your project's pipeline (usually 'master'). For
    example, `git checkout -b great-feature`.
2.  Make and commit changes to your project as you normally do.
3.  Submit your change to Workflow with the command `delivery review`.
    If you desire to target a pipeline other than the default one, add
    the pipeline flag `--pipeline=$PIPELINE`. This command will output a
    URL to view the details and progress of the change through Workflow;
    the Verify phase will begin automatically and a corresponding Pull
    Request will be opened in GitHub.

### Code Review

You may conduct a code review using either Workflow or GitHub; however,
the merging of a pull request is handled by Workflow and occurs when a
change in Workflow is approved.

{{< warning >}}

Do not merge the pull request from within GitHub.

{{< /warning >}}

To perform code review using Workflow:

1.  Use the URL created by `delivery review` to go directly to the
    change, or browse to the change from the Workflow Dashboard or from
    the link provided in the first comment of your GitHub pull request.
2.  Click the `Review` tab.
3.  Browse the changes and make comments.

### Approving a Change (Merging a Pull Request)

When the Verify phase has passed in Workflow and the code has been
reviewed and is ready to be merged, approve the change in Workflow; the
pull request will be merged and closed in GitHub. The feature branch
will also be deleted in GitHub.

1.  Use the URL created by `delivery review` to go directly to the
    change, or browse to the change from the Delivery Dashboard or from
    the link provided in the first comment of your GitHub pull request.
2.  Click the `Review` tab.
3.  Click `Approve`.

### Deleting a Change (Declining a Pull Request)

When the Verify phase has passed in Workflow and the code has been
reviewed and it is decided the change should never be approved, delete
the change in Workflow; the pull request will be declined and closed in
GitHub. The feature branch will also be deleted in GitHub.

1.  Use the URL created by `delivery review` to go directly to the
    change, or browse to the change from the Workflow Dashboard or from
    the link provided in the first comment of your GitHub pull request.
2.  Click the `Review` tab.
3.  Click `Delete`.