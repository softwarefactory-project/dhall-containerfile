#!/bin/env python3
# Copyright 2020 Red Hat
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

# Keep README.md updated
import subprocess
import os
os.environ["DHALL_ZUUL"] = "./package.dhall"
doc_orig = open('README.md').read().split('\n')

def render(name, doc):
    line = '-- ./examples/%s.dhall' % name
    dhallstart = doc.index(line)
    dhallend = doc[dhallstart:].index('```') + dhallstart
#    print("Dhall", dhallstart, dhallend)
    demostart = doc[dhallstart:].index('```text') + dhallstart
    demoend = doc[demostart:].index('```') + demostart
#    print("Demo", demostart, demoend)
    demopath = "./examples/%s.dhall" % name
    demoexpr = "(%s).Containerfile" % demopath
    demo = subprocess.Popen(['dhall', 'text'], stdout=subprocess.PIPE, stdin=subprocess.PIPE)
    demoOutput = ["# dhall text <<< '%s'" % demoexpr] + demo.communicate(demoexpr.encode('utf-8'))[0].decode('utf-8').split('\n')[1:]
    return doc[:dhallstart + 1] + open(demopath).read().split('\n') + \
        doc[dhallend:demostart + 1] + demoOutput + doc[demoend:]

newdoc = doc_orig
for demo in ["ffmpeg"]:
    newdoc = render(demo, newdoc)

exit(0) if newdoc == doc_orig else open('README.md', 'w').write('\n'.join(newdoc)); print('README.md updated!')
