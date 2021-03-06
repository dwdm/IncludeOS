// This file is a part of the IncludeOS unikernel - www.includeos.org
//
// Copyright 2015 Oslo and Akershus University College of Applied Sciences
// and Alfred Bratterud
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#pragma once
#ifndef POSIX_SYS_UTSNAME_H
#define POSIX_SYS_UTSNAME_H

#ifdef __cplusplus
extern "C" {
#endif

struct utsname {
  static const int LENGTH = 256;

  /* Name of this implementation of the operating system */
  char sysname[LENGTH];

  /* Name of this node within the communications network to
  which this node is attached, if any */
  char nodename[LENGTH];

  /* Current release level of this implementation */
  char release[LENGTH];

  /* Current version level of this release */
  char version[LENGTH];

  /* Name of the hardware type on which the system is running */
  char machine[LENGTH];
};

int uname(struct utsname *name);

#ifdef __cplusplus
}
#endif

#endif
