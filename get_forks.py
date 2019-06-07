#!/usr/bin/env python3

import requests
import json
import os 
import subprocess 

import argparse

if __name__ == '__main__':
    PARSER = argparse.ArgumentParser(
            formatter_class=argparse.ArgumentDefaultsHelpFormatter,
            description='''
                gets a list of forks for a given github user 
            '''
            )

    PARSER.add_argument('-u', '--user', required=True, help='github user name')

    args = PARSER.parse_args()

    res = requests.get("https://api.github.com/users/{}/repos?per_page=100".format(args.user))
    repos = res.json()
   
    while 'next' in res.links.keys():
        res=requests.get(res.links['next']['url'])
        repos.extend(res.json())

    for repo in repos:
        html_url = repo['html_url']
        
        if repo['fork']:
            repo_relative_path = html_url.rsplit('/', 1)[-1]
            print(args.user + '/' + repo_relative_path)
