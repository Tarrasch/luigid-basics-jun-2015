import os
import shutil
import time

import luigi

class T(luigi.Task):
    def run(self):
        time.sleep(30)

class A(T):

    def requires(self):
        return [B(), C()]

class B(T):
    def requires(self):
        return [D()]

class C(T):
    def requires(self):
        return []

class D(T):
    def requires(self):
        return []

    def run(self):
        raise ValueError('No')


if __name__ == "__main__":
    if os.path.exists('/tmp/bar'):
        shutil.rmtree('/tmp/bar')

    luigi.build([A()])

