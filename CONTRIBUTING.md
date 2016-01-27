How to contribute
=================

Contributions to GeoTV are welcome, thanks for your help! Here are a few
guidelines to keep in mind:

Create a fork
-------------

To contribute your changes, you'll need to fork the git repository.

  1. Fork the GeoTV repository using Github

  2. Clone your fork

    ```shell
    git clone https://github.com/my-user-name/geotv.git
    ```

  3. Create a new remote for the upstream repository

    ```shell
    cd geotv
    git remote add upstream https://github.com/electrickite/geotv.git
    ```

Submit a Pull Request
---------------------

If you can, please submit a pull request with the fix or improvement. Before
working on a feature or bug fix, please search [GitHub][1] for an open or
closed pull request that relates to your idea. You don't want to duplicate
effort.

It is very important to separate new features or improvements into feature
branches, and to send a pull request for each branch. This allows each new
change to be reviewed individually.

To create a Pull Request:

  1. If necessary, sync your fork with upstream:

    ```shell
    git fetch upstream
    git checkout master
    git merge upstream/master
    ```

  2. Create a new git branch for your change:

    ```shell
    git checkout -b my-fix-branch master
    ```

  3. Write code, fix bug, implement feature, etc. In short, hack away!

  4. Commit your changes using a descriptive commit message.
     Note: the optional commit `-a` command line option will automatically "add"
     and "rm" edited files.

    ```shell
    git commit -a
    ```

  5. Push your branch to GitHub:

    ```shell
    git push origin my-fix-branch
    ```

  6. In GitHub, send a pull request to `geotv:master`.

If we suggest changes to your submission:

  1. Make the requested updates.
  2. Commit your changes to your branch (e.g. `my-fix-branch`).
  3. Push the changes to your GitHub fork (this will update your Pull Request).

### Commit history

To keep the commit history clean and help evaluate your PR, try to submit as few
commits as possible.

  * For a small change or bug fix, submit all changes in a single commit
  * For new features, several commits with descriptive messages are fine as long
    as they help with understanding the contents of the PR

If the PR contains several commits or gets too outdated we may ask you to rebase
and force push to update the PR. In this case, use the git interactive rebase
command:

  ```shell
  git fetch upstream
  git checkout my-fix-branch
  git rebase master -i
  
  # Squash all but the latest commit. Create a new descriptive commit message
  
  git push origin my-fix-branch -f
  ```

Once you push, the Pull Request will auto-update and will only contain your
single, squashed commit.

Style Guide
-----------

All code must adhere to the [MODX Code Standards][2]. In addition, be sure to
end all files with a newline.

Localization
------------

Language files should follow the default (en) lexicon as closely as possible.


[1]: https://github.com/electrickite/geotv/pulls
[2]: https://rtfm.modx.com/revolution/2.x/developing-in-modx/code-standards
