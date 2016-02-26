pkg_name=file
pkg_origin=chef
pkg_version=5.24
pkg_maintainer="The Bldr Maintainers <bldr@chef.io>"
pkg_license=('custom')
pkg_source=ftp://ftp.astron.com/pub/$pkg_name/${pkg_name}-${pkg_version}.tar.gz
pkg_shasum=802cb3de2e49e88ef97cdcb52cd507a0f25458112752e398445cea102bc750ce
pkg_deps=(chef/glibc chef/zlib)
pkg_build_deps=(chef/coreutils chef/diffutils chef/patch chef/make chef/gcc)
pkg_binary_path=(bin)
pkg_include_dirs=(include)
pkg_lib_dirs=(lib)
pkg_gpg_key=3853DA6B

do_prepare() {
  do_default_prepare

  # Add explicit linker instructions as the binutils we are using may have its
  # own dynamic linker defaults. This is necessary because this Plan is built
  # before the `chef/binutils` Plan which will set the new `chef/glibc` dynamic
  # linker for all later Plans.
  dynamic_linker="$(pkg_path_for glibc)/lib/ld-linux-x86-64.so.2"
  LDFLAGS="$LDFLAGS -Wl,-rpath=${LD_RUN_PATH},--enable-new-dtags"
  LDFLAGS="$LDFLAGS -Wl,--dynamic-linker=$dynamic_linker"
  export LDFLAGS
  build_line "Updating LDFLAGS=$LDFLAGS"
}

do_check() {
  make check
}

do_install() {
  make install

  # As per the copyright, we must include the copyright statement in binary
  # distributions
  #
  # Source: https://github.com/file/file/blob/master/COPYING
  install -v -Dm644 COPYING "$pkg_path/share/COPYING"
}


# ----------------------------------------------------------------------------
# **NOTICE:** What follows are implementation details required for building a
# first-pass, "stage1" toolchain and environment. It is only used when running
# in a "stage1" Studio and can be safely ignored by almost everyone. Having
# said that, it performs a vital bootstrapping process and cannot be removed or
# significantly altered. Thank you!
# ----------------------------------------------------------------------------
if [[ "$STUDIO_TYPE" = "stage1" ]]; then
  pkg_build_deps=()
fi
