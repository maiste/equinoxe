Tests for (glob_files_rec <dir>/<glob>). This feature is not meat to
be release as it. We plan to replace it by recursive globs for 3.0.0.

  $ cat > dune-project <<EOF
  > (lang dune 2.9)
  > EOF

  $ cat > dune <<EOF
  > (rule
  >  (alias x)
  >  (deps (glob_files_rec foo/*.txt))
  >  (action (bash "for i in %{deps}; do printf \"\$i\\n\"; done")))
  > EOF

  $ mkdir -p foo/a/b1/c
  $ mkdir -p foo/a/b2/c
  $ mkdir -p foo/a/b3/c

  $ touch foo/x.txt
  $ touch foo/a/x.txt
  $ touch foo/a/b1/c/x.txt
  $ touch foo/a/b1/c/y.txt
Leave a/b2/c empty to make sure we don't choke on empty dirs.
  $ touch foo/a/b3/x.txt
  $ touch foo/a/b3/x.other

  $ dune build @x
          bash alias x
  foo/a/b1/c/x.txt
  foo/a/b1/c/y.txt
  foo/a/b3/x.txt
  foo/a/x.txt
  foo/x.txt

  $ find . -name \*.txt | dune_cmd count-lines
  10
  $ dune build @x --force 2>&1 | dune_cmd count-lines
  6

Check that generated files are taken into account
-------------------------------------------------

  $ cat > foo/dune <<EOF
  > (rule
  >  (target gen.txt)
  >  (action (with-stdout-to %{target} (echo ""))))
  > EOF

  $ dune build @x --force 2>&1 | grep gen.txt
  foo/gen.txt

Check that generated directories are ignored
--------------------------------------------

  $ cat > dune <<EOF
  > (library
  >  (name foo))
  > 
  > (rule
  >  (alias x)
  >  (deps (glob_files_rec *.cmi))
  >  (action (bash "for i in %{deps}; do echo \$i; done")))
  > EOF

  $ touch foo/foo.ml

  $ dune build

  $ find _build -name \*.cmi
  _build/default/.foo.objs/byte/foo.cmi

  $ dune build @x

