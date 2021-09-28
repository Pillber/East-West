extends Control


onready var list = $PlayerList
var votes = {}
var votes_cast = 0

#Create a dictionary of player names and votes for them
func _ready():
	for p in Network.players:
		votes[Network.players[p]["name"]] = 0
	votes["SKIP VOTE"] = 0
	update_player_list()
	update_vote_count()



#Will display each player & #Of Votes for them
func update_player_list():
	list.clear()
	for v in votes:
		list.add_item(str(v) + " - " + str(votes[v]), null, true)
		
func update_vote_count():
	pass

remotesync func add_vote(vote):
	votes[vote] += 1
	votes_cast += 1
	update_player_list()
	
	if get_tree().is_network_server() && votes_cast == votes.size()-1:
		count_votes()

func count_votes():
	var high = 0
	var voted = ""
	for v in votes:
		if votes[v] > high:
			high = votes[v]
			voted = v
			
	print(voted)
			

func _on_VoteButton_pressed():
	if list.is_anything_selected():
		var vote = str(list.get_item_text(list.get_selected_items()[0])).split(" - ")[0]
		rpc("add_vote", vote)
		$VoteButton.disabled = true

		
		
		
		
