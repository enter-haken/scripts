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
                gets days left in relation to a given date
            '''
            )

    PARSER.add_argument('-u', '--user', required=True, help='github user name')

    args = PARSER.parse_args()

    res = requests.get("https://api.github.com/users/{}/repos?per_page=100".format(args.user))
    repos = res.json()

    while 'next' in res.links.keys():
        res=requests.get(res.links['next']['url'])
        repos.extend(res.json())

    public_urls = [repo['html_url'] for repo in repos]
    descriptions = [repo['name'] + ': ' + repo['description'] for repo in repos if repo['description']]

    if not os.path.isdir(args.user):
        os.mkdir(args.user)

    os.chdir(args.user)

    f = open("repo_descriptions.txt","w")
    for description in descriptions:
        f.write(description + '\n')
    f.close()

    for repo in public_urls:
        repo_relative_path = repo.rsplit('/', 1)[-1]
        if not os.path.isdir(repo_relative_path):
            print("cloning {} into {}".format(repo, repo_relative_path))
            os.system("git clone {}".format(repo))
        else:
            print("pulling {} into {}".format(repo, repo_relative_path))
            os.system("git -C {}  pull".format(repo_relative_path))
