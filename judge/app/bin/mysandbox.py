#!/usr/bin/env python
################################################################################
# Sandbox Libraries (Python) - Sample Script                                   #
#                                                                              #
# Copyright (C) 2009-2011 LIU Yu, <pineapple.liu@gmail.com>                    #
# All rights reserved.                                                         #
#                                                                              #
# Redistribution and use in source and binary forms, with or without           #
# modification, are permitted provided that the following conditions are met:  #
#                                                                              #
# 1. Redistributions of source code must retain the above copyright notice,    #
#    this list of conditions and the following disclaimer.                     #
#                                                                              #
# 2. Redistributions in binary form must reproduce the above copyright notice, #
#    this list of conditions and the following disclaimer in the documentation #
#    and/or other materials provided with the distribution.                    #
#                                                                              #
# 3. Neither the name of the author(s) nor the names of its contributors may   #
#    be used to endorse or promote products derived from this software without #
#    specific prior written permission.                                        #
#                                                                              #
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"  #
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE    f#
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE   #
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE     #
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR          #
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF         #
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS     #
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN      #
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)      #
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE   #
# POSSIBILITY OF SUCH DAMAGE.                                                  #
################################################################################

# judge script.
# @author wistery_k

import os
import sys
import tempfile

from sandbox import *

system, machine = os.uname()[0], os.uname()[4]

if system not in ('Linux', ) or machine not in ('i686', 'x86_64', ):
    raise AssertionError("Unsupported platform type.\n")

def main(args):

    if len(args) < 4:
        print "usage: python %s time_limit memory_limit command" % args[0]
        return os.EX_USAGE

    # sandbox configuration
    cookbook = {
        'args': args[3:],                    # targeted program
        'stdin': sys.stdin,                  # input to targeted program
        'stdout': sys.stdout,                # output from targeted program
        'stderr': tempfile.TemporaryFile(),  # error from targeted program
        'quota': dict(wallclock = 30000,     # 30 sec
                      cpu = int(args[1]),    # 2000 to be 2 sec
                      memory = int(args[2]), # 2**28 to be 256 MB
                      disk = 1048576)}       # 1 MB

    # create a sandbox instance and execute till end
    sbox = MiniSandbox(**cookbook)
    sbox.run()

    # verbose statistics
    sys.stderr.write("%(result)s\n%(cpu)d %(mem)d\n" % sbox.probe())
    return os.EX_OK

# safe list of linux syscall no.
sc_safe = dict(i686 = set([3, 4, 19, 45, 54, 90, 91, 122, 125, 140, 163, 192, \
    197, 224, 243, 252, ]), x86_64 = set([0,1,2,3,5,9,10,11,12,21,158,231]))

# mini sandbox with embedded policy
class MiniSandbox(SandboxPolicy,Sandbox):
    sc_table = None
    def __init__(self, *args, **kwds):
        # initialize table of system call rules
        self.sc_table = [self._KILL_RF, ] * 1024
        for scno in sc_safe[machine]:
            self.sc_table[scno] = self._CONT
        # initialize as a polymorphic sandbox-and-policy object
        kwds['policy'] = self
        SandboxPolicy.__init__(self)
        Sandbox.__init__(self, *args, **kwds)
    def probe(self):
        # add custom entries into the probe dict
        d = Sandbox.probe(self, False)
        d['cpu'] = d['cpu_info'][0]
        d['mem'] = d['mem_info'][1]
        d['result'] = result_name(self.result)
        return d
    def __call__(self, e, a):
        # handle SYSCALL/SYSRET events with local handlers
        if e.type in (S_EVENT_SYSCALL, S_EVENT_SYSRET):
            if machine is 'x86_64' and e.ext0 is not 0:
                return self._KILL_RF(e, a)
            return self.sc_table[e.data](e, a)
        # bypass other events to base class
        return SandboxPolicy.__call__(self, e, a)
    def _CONT(self, e, a): # continue
        a.type = S_ACTION_CONT
        return a
    def _KILL_RF(self, e, a): # restricted func.
        a.type, a.data = S_ACTION_KILL, S_RESULT_RF
        return a

# result code translation
def result_name(r):
    return ('PD', 'OK', 'RF', 'ML', 'OL', 'TL', 'RT', 'AT', 'IE', 'BP')[r] \
        if r in xrange(10) else None

if __name__ == "__main__":
    sys.exit(main(sys.argv))
