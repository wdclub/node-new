#!/bin/sh

#  ETHER-1 Service Node docker template
#  Copyright © 2019 cryon.io
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Affero General Public License as published
#  by the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Affero General Public License for more details.
#
#  You should have received a copy of the GNU Affero General Public License
#  along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
#  Contact: cryi@tutanota.com

ipfs init --profile server
ipfs bootstrap rm --all
_maxstorage="16GB"
ipfs config Datastore.StorageMax $_maxstorage
ipfs config --json Swarm.ConnMgr.LowWater 400
ipfs config --json Swarm.ConnMgr.HighWater 600
ipfs bootstrap add /ip4/207.148.27.84/tcp/4001/ipfs/QmTFUcUuMSN7KLytjtqnHCjixqd4ig3PrSbdQ2mW9Q8qeY
ipfs bootstrap add /ip4/66.42.109.75/tcp/4001/ipfs/QmV856mLWnTDaj5LQvS3dCa3qjz4DNC9cKQJNSrwtqcHzT
ipfs bootstrap add /ip4/95.179.136.216/tcp/4001/ipfs/QmdFCa2ix51sV8FADGKDadKPGB55kdEQMZm9VKVSRTbVhC
ipfs bootstrap add /ip4/45.63.116.102/tcp/4001/ipfs/QmSfEKCzPWA6MmG2ZLK4Vqnq6oB6rvrLyUpHdNqng5nQ4t
ipfs bootstrap add /ip4/149.28.167.176/tcp/4001/ipfs/QmRwQ49Zknc2dQbywrhT8ArMDS9JdmnEyGGy4mZ1wDkgaX
ipfs bootstrap add /ip4/140.82.54.221/tcp/4001/ipfs/QmeG81bELkgLBZFYZc53ioxtvRS8iNVzPqxUBKSuah2rcQ
ipfs bootstrap add /ip4/45.77.170.137/tcp/4001/ipfs/QmTZsBNb7dfJJmwuAdXBjKZ7ZH6XbpestZdURWGJVyAmj2
ipfs config profile apply