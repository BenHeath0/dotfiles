# Notes

things that are useful for dev but i dont want them in my apple notes anymore

`I need to kill all my processes on prestage/preprod`
killall -u ben_heath_rechargeapps_com

`tests are failing to run wtf`
rm -rf config/docker/development

`Hey my tests dont run!`

- run “fixtest” to wipe stuff
- run “docker system/image/volume prune” to prune stuff

`git rebase --onto`

```
ex/
- feature-A branched off of Master
- feature-B branched off of feature-A
- feature-A squashed and merged into master

DO:
git checkout feature-B
git rebase --onto master feature-A feature-B
```
