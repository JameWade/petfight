<a href="https://twitter.com/Jamewades">
<img src="https://img.shields.io/twitter/follow/Jamewades?style=social"/>

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

# petfight
## Overview
cairo2 game like q宠大乐斗 on starknet
## design
通过活力值控制每天的比赛次数，活力值每天会自动更新，用户在活力值足够的情况下就可以发起与好友的PK活动，胜利方获取更多的经验，失败方获取少量经验。  

The number of matches per day is controlled through the vitality value. The vitality value will be automatically updated every day. When the vitality value is sufficient, the user can initiate a PK activity with friends. The winner will get more experience, and the loser will get a small amount of experience.
### pet
用户可以在社区和朋友进行宠物pk，pk自动进行，宠物根据链上随机性选择自己的武器、技能进行攻击，根据宠物自身属性发起攻击，攻击自动进行，直到一方获胜.  

Users can engage in pet pk with friends in the community. The pk will be carried out automatically. The pet will obtain its own weapons and skills based on randomness on the chain, and launch an attack based on the pet's own attributes. The attack will be carried out automatically until one party wins.
### weapon 
武器是通过用户不断提升自身等级而获取，随着比赛场次增多，等级提升就可以解锁更优质的武器。解锁武器存在一定概率时间，越高等级的武器解锁概率越低。同时武器自身也可以升级，分为五个等级，等级不同对应的攻击力也不同。  

Weapons are obtained by users continuously upgrading their level. As the number of games increases, higher-quality weapons can be unlocked as the level increases. There is a certain probability time for unlocking weapons. The higher the level of weapons, the lower the probability of unlocking them. At the same time, the weapon itself can also be upgraded and is divided into five levels. Different levels have different attack powers.
### 技能
技能机制与武器机制一样，但是用户每次升级只能获取武器和技能的一种，而不是两种都可以获取。  

The skill mechanism is the same as the weapon mechanism, but users can only obtain one weapon and skill each time they level up, instead of both。
## Contribute
每个人都可以申请提交PR到项目。  

Everyone can apply to submit PR to the project
