Create Nix expressions for python packages
==========================================


wheels.nix
----------

Extracted from python branch from chaoflow's work.

    https://github.com/chaoflow/nixpkgs/tree/python/pkgs/development/python-wheels

::

    pyEnv = python.buildEnv {
      buildInput = [];
      propagatedBuildInput
    };

    python






A tool that generates `nix expressions`_ for your python packages, so you
don't have to.

To simply create development environment for you python project you
simply do:::

Using ``setuptools``::

    # not yet working
    % pypi2nix setup.py

Using ``requirements.txt`` (created by ``pip freeze``)::

    # working but only if you provide full set of dependencies
    # eg. pip freeze will give you this
    % pypi2nix requirements.txt

Using ``zc.buildout``::

    # not yet working
    % pypi2nix buildout.cfg

To step into development environment::

    % nix-shell

How ``pypi2nix`` works internally look at `Design`_ section of this document.


Installation
------------

Install ``pypi2nix`` by running:::

    % nix-env -i pypi2nix


Contribute
----------

- Issue Tracker: https://github.com/NixOS/pypi2nix
- Source Code: https://github.com/NixOS/pypi2nix

To develop ``pypi2nix``:::

    % git clone git://github.com/NixOS/pypi2nix.git
    % nix-shell

To build `pypi2nix` binary::

    % make clear install DESTDIR=./out

As example you can try generate Sentry's delependencies::

    % cd examples
    % ./../out/pypi2nix sentry.nix --nix-path=nixpkgs=/path/to/nixpkgs-chaoflows-python-branch

Code away!

If you are having issues, please let us know via issue tracker.


Design
------

::

    % pypi2nix <input>

Above command will first generate ``generated.json`` file which includes md5
hashes for all python packages we need to package. We used JSON format here
because its easy to read from nix and python, and this step is used to cache
all lookups to pypi on any subsequent calls.

Then it will use it to build python wheels inside ``/nix/store`` and read all
metadata (description, homepage, license, requires, ...) and create
``generated.nix``.

Last piece to connect everything together is ``default.nix``. This file is
going to be generated and if file already exists it will ask you if you want to
override it.

And that's it. Looks complicated, but that's just the way python packaging is.

You should read more about `nix-shell`_ and how to use it with ``default.nix``
to get most out of python development with nix.


License
-------

.. _`nix expressions`: http://nixos.org/nix/manual/#chap-writing-nix-expressions
.. _`nixpkgs`: https://github.com/NixOS/nixpkgs
.. _`nix-shell`: http://nixos.org/nix/manual/#sec-nix-shell
