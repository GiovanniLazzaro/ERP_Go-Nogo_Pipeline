#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Generate a pseudo-randomised Go/No-Go condition file for gonogo_task.py.

Constraints:
  * exact proportion of Go / NoGo trials (default 80% / 20%)
  * the first trial is always Go
  * no two NoGo trials in a row

Each NoGo is placed right after a distinct Go trial, so the constraints hold by
construction (no post-hoc replacement, which would change the 80/20 ratio).

Output columns (as read by gonogo_task.py):
  stim_type   'go' / 'nogo'           -> selects the stimulus trigger
  Color       fill colour of the circle
  corrAnswer  'space' for Go, 'none' for NoGo

Usage:
  python generate_conditions.py --list 1 --seed 1
  python generate_conditions.py --list 4 --n-trials 200 --p-go 0.8 --seed 42

Requires: pandas + openpyxl (both ship with PsychoPy standalone).
"""
import argparse
import os
import random

import pandas as pd

GO_COLOR = 'green'
NOGO_COLOR = 'red'


def make_sequence(n_trials=200, p_go=0.8, seed=None):
    rng = random.Random(seed)
    n_go = round(n_trials * p_go)
    n_nogo = n_trials - n_go
    if n_nogo > n_go:
        raise ValueError('Cannot avoid consecutive NoGo trials with p_go < 0.5')
    # choose which Go trials are followed by a NoGo
    followed_by_nogo = set(rng.sample(range(n_go), n_nogo))
    seq = []
    for i in range(n_go):
        seq.append('go')
        if i in followed_by_nogo:
            seq.append('nogo')
    return seq


def check_sequence(seq, n_trials, p_go):
    assert len(seq) == n_trials
    assert seq.count('go') == round(n_trials * p_go)
    assert seq[0] == 'go'
    assert all(not (a == b == 'nogo') for a, b in zip(seq, seq[1:]))


def main():
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('--list', default='1', help='list id, output CONDITION_<list>.xlsx')
    parser.add_argument('--n-trials', type=int, default=200)
    parser.add_argument('--p-go', type=float, default=0.8)
    parser.add_argument('--seed', type=int, default=None, help='set for a reproducible list')
    parser.add_argument('--outdir', default=os.path.join(os.path.dirname(os.path.abspath(__file__)),
                                                          'conditions'))
    args = parser.parse_args()

    seq = make_sequence(args.n_trials, args.p_go, args.seed)
    check_sequence(seq, args.n_trials, args.p_go)

    df = pd.DataFrame({
        'stim_type': seq,
        'Color': [GO_COLOR if s == 'go' else NOGO_COLOR for s in seq],
        'corrAnswer': ['space' if s == 'go' else 'none' for s in seq],
    })
    os.makedirs(args.outdir, exist_ok=True)
    out = os.path.join(args.outdir, 'CONDITION_{}.xlsx'.format(args.list))
    df.to_excel(out, index=False)
    print('Saved {} ({} Go, {} NoGo)'.format(out, seq.count('go'), seq.count('nogo')))


if __name__ == '__main__':
    main()
