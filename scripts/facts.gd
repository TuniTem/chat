extends Node2D
# you lost the game
# 

@onready var fact: RichTextLabel = $MarginContainer/VBoxContainer/MarginContainer/Fact
@onready var texture: TextureRect = $MarginContainer/VBoxContainer/HBoxContainer/Texture
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const FISHIES : Dictionary = {
	"Angelfish" : preload("res://art/Webphishing/webfishfish/ship/Angelfish.png"),
	"Axolotl" : preload("res://art/Webphishing/webfishfish/ship/Axolotl.png"),
	"Bull_Shark" : preload("res://art/Webphishing/webfishfish/ship/Bull_Shark.png"),
	"Dogfish" : preload("res://art/Webphishing/webfishfish/ship/Dogfish.png"),
	"Frog" : preload("res://art/Webphishing/webfishfish/ship/Frog.png"),
	"King_Salmon" : preload("res://art/Webphishing/webfishfish/ship/King_Salmon.png"),
	"Lobster" : preload("res://art/Webphishing/webfishfish/ship/Lobster.png"),
	"Manta_Ray" : preload("res://art/Webphishing/webfishfish/ship/Manta_Ray.png"),
	"Man_O'_War" : preload("res://art/Webphishing/webfishfish/ship/Man_O'_War.png"),
	"Swordfish" : preload("res://art/Webphishing/webfishfish/ship/Swordfish.png"),
	"Alligator" : preload("res://art/Webphishing/webfishfish/ship/Alligator.png"),
	"Anomalocaris" : preload("res://art/Webphishing/webfishfish/ship/Anomalocaris.png"),
	"Atlantic_Salmon" : preload("res://art/Webphishing/webfishfish/ship/Atlantic_Salmon.png"),
	"Bluefish" : preload("res://art/Webphishing/webfishfish/ship/Bluefish.png"),
	"Bluegill" : preload("res://art/Webphishing/webfishfish/ship/Bluegill.png"),
	"Bowfin" : preload("res://art/Webphishing/webfishfish/ship/Bowfin.png"),
	"Carp" : preload("res://art/Webphishing/webfishfish/ship/Carp.png"),
	"Catfish" : preload("res://art/Webphishing/webfishfish/ship/Catfish.png"),
	"Clownfish" : preload("res://art/Webphishing/webfishfish/ship/Clownfish.png"),
	"Coelacanth" : preload("res://art/Webphishing/webfishfish/ship/Coelacanth.png"),
	"Crab" : preload("res://art/Webphishing/webfishfish/ship/Crab.png"),
	"Crappie" : preload("res://art/Webphishing/webfishfish/ship/Crappie.png"),
	"Crayfish" : preload("res://art/Webphishing/webfishfish/ship/Crayfish.png"),
	"Drum" : preload("res://art/Webphishing/webfishfish/ship/Drum.png"),
	"Eel" : preload("res://art/Webphishing/webfishfish/ship/Eel.png"),
	"Flounder" : preload("res://art/Webphishing/webfishfish/ship/Flounder.png"),
	"Gar" : preload("res://art/Webphishing/webfishfish/ship/Gar.png"),
	"Golden_Bass" : preload("res://art/Webphishing/webfishfish/ship/Golden_Bass.png"),
	"Goldfish" : preload("res://art/Webphishing/webfishfish/ship/Goldfish.png"),
	"Great_White_Shark" : preload("res://art/Webphishing/webfishfish/ship/Great_White_Shark.png"),
	"Grouper" : preload("res://art/Webphishing/webfishfish/ship/Grouper.png"),
	"Guppy" : preload("res://art/Webphishing/webfishfish/ship/Guppy.png"),
	"Hammerhead_Shark" : preload("res://art/Webphishing/webfishfish/ship/Hammerhead_Shark.png"),
	"Helicoprion" : preload("res://art/Webphishing/webfishfish/ship/Helicoprion.png"),
	"Herring" : preload("res://art/Webphishing/webfishfish/ship/Herring.png"),
	"Horseshoe_Crab" : preload("res://art/Webphishing/webfishfish/ship/Horseshoe_Crab.png"),
	"Koi" : preload("res://art/Webphishing/webfishfish/ship/Koi.png"),
	"Krill" : preload("res://art/Webphishing/webfishfish/ship/Krill.png"),
	"Largemouth_Bass" : preload("res://art/Webphishing/webfishfish/ship/Largemouth_Bass.png"),
	"Leech" : preload("res://art/Webphishing/webfishfish/ship/Leech.png"),
	"Leedsichthys" : preload("res://art/Webphishing/webfishfish/ship/Leedsichthys.png"),
	"Lionfish" : preload("res://art/Webphishing/webfishfish/ship/Lionfish.png"),
	"Marlin" : preload("res://art/Webphishing/webfishfish/ship/Marlin.png"),
	"Mooneye" : preload("res://art/Webphishing/webfishfish/ship/Mooneye.png"),
	"Muskellunge" : preload("res://art/Webphishing/webfishfish/ship/Muskellunge.png"),
	"Octopus" : preload("res://art/Webphishing/webfishfish/ship/Octopus.png"),
	"Oyster" : preload("res://art/Webphishing/webfishfish/ship/Oyster.png"),
	"Perch" : preload("res://art/Webphishing/webfishfish/ship/Perch.png"),
	"Pike" : preload("res://art/Webphishing/webfishfish/ship/Pike.png"),
	"Pupfish" : preload("res://art/Webphishing/webfishfish/ship/Pupfish.png"),
	"Rainbow_Trout" : preload("res://art/Webphishing/webfishfish/ship/Rainbow_Trout.png"),
	"Salmon" : preload("res://art/Webphishing/webfishfish/ship/Salmon.png"),
	"Sawfish" : preload("res://art/Webphishing/webfishfish/ship/Sawfish.png"),
	"Seahorse" : preload("res://art/Webphishing/webfishfish/ship/Seahorse.png"),
	"Sea_Turtle" : preload("res://art/Webphishing/webfishfish/ship/Sea_Turtle.png"),
	"Shrimp" : preload("res://art/Webphishing/webfishfish/ship/Shrimp.png"),
	"Snail" : preload("res://art/Webphishing/webfishfish/ship/Snail.png"),
	"Squid" : preload("res://art/Webphishing/webfishfish/ship/Squid.png"),
	"Sting_Ray" : preload("res://art/Webphishing/webfishfish/ship/Sting_Ray.png"),
	"Sturgeon" : preload("res://art/Webphishing/webfishfish/ship/Sturgeon.png"),
	"Sunfish" : preload("res://art/Webphishing/webfishfish/ship/Sunfish.png"),
	"Toad" : preload("res://art/Webphishing/webfishfish/ship/Toad.png"),
	"Tuna" : preload("res://art/Webphishing/webfishfish/ship/Tuna.png"),
	"Turtle" : preload("res://art/Webphishing/webfishfish/ship/Turtle.png"),
	"Walleye" : preload("res://art/Webphishing/webfishfish/ship/Walleye.png"),
	"Whale" : preload("res://art/Webphishing/webfishfish/ship/Whale.png"),
	"Wolffish" : preload("res://art/Webphishing/webfishfish/ship/Wolffish.png")
}

const FACTS : Dictionary[String, Array] = {
	"Angelfish" : [
		"Marine angelfish can change gender in response to social structure. In many species, the dominant female can become male if the male dies",
		"Thankfully, this angelfish is NOT biblically accurate"
	],
	"Axolotl" : [
		"You lost the game! - Axolotol",
		"Humanity will bend under the axolotol's might",
		"The axolotol's cuteness is their greatest weapon",
		"The axolotl demands capitulation"
	],
	"Bull_Shark" : [
		"Bull sharks can survive in both salt and fresh water",
		"Technically, you’re never safe from sharks",
		"Sharkies are pretty cool",
		"Bull sharks gathered their name for their hatred of the colour red, true fact!",
		"Pregnant bull sharks move from coastal environments into rivers to give birth"
	],
	"Dogfish" : [
		"The Dogfish's name comes from their tendency to hunt in packs like dogs - not because they’re particularly loyal",
		"Despite their name, dogfish are NOT cute",
		"Dogfish are not to be confused with pupfish- pupfish are the dogfish's newer cousin in evolution",
		"Spiny dogfish likely have the longest birthing period of any vertebrate- up to 24 months"
	],
	"Frog" : [
		"A tree frog's lil sticky toe pads work through surface tension and mucus secretion - not suction",
		"Frogs are very socially awkward, conversation is not reccomended",
		"Forg",
		"Frogs swallow food with the help of their eye muscles"
	],
	"King_Salmon" : [
		"Some king salmon stay in freshwater their whole lives instead of migrating to the ocean - these are called \"residents\"",
		"The King Salmon's Royalty title is self-appointed",
		"King salmon lords over his dominion against the oppressive might of the axolotl",
		"The king salmon can grow up to 5 feet in length!"
	],
	"Lobster" : [
		"The Lobster tastes with their legs and chews with their stomachs. Their \"teeth\" are in their stomachs. Nature is wacky like that",
		"lowbstah!",
		"Lobster? I hardly know 'er!"
	],
	"Manta_Ray" : [
		"The manta ray have the largest brain-to-body ratio of any cold-blooded fish and can pass the mirror test- possibly self-aware.",
		"The manta ray is a graceful sea-pancake with the emotional depth of a philosopher."
	],
	"Man_O'_War" : [
		"A Man O' War jellyfish is not a single animal- it's a siphonophore, a colony of specialized organisms working together"
	],
	"Swordfish" : [
		"Not only are they fast, but swordfish can heat up their eyes and brain for better vision during deep dives- useful for hunting.",
		"The swordfish would probably be pretty good at fencing if you think about it"
	],
	"Alligator" : [
		"Like humans, alligators can replace their teeth throughout their lives",
		"The alligator wiggles its little toesey woesesy in excitement when it finds prey",
		"Alligator? I hardly know 'er!",
		"See you later, alligator!",
		"In awhile, crocodile!",
		"Bye bye butterfly!",
		"Give a hug, ladybug!",
		"Blow a kiss, jellyfish!",
		"See you soon, big baboon",
		"Out the door, dinosaur",
		"Take care, polar bear",
		"Gotta go, buffalo!",
		"See you soon, racoon!",
		"In a shake, garden snake!",
		"Can't stay, blue jay!",
		"Toodle-loo, kangaroo!",
		"Time to scoot, little newt",
		"'Till then, penguin",
	],
	"Anomalocaris" : [
		"You either find the anomalocaris super cute, or terrifying. Either way there's purchasable plushes",
		"The anomalocaris had a series of paired, flexible lobes running along either side of its body that it used as a giant fin for movement"
	],
	"Atlantic_Salmon" : [
		"The atlantic salmon is, in fact, one of the last surviving species of residents from the city of atlantis",
		"Atlantic salmon are anadromous, meaning they migrate between freshwater and saltwater environments during their life cycle"
	],
	"Bluefish" : [
		"Unfortunately, this fish is blue",
		"Why so sad lil guy?",
		"One fish, two fish, red fish, bluefish",
		"The bluefish is known as the \"marine piranha\" because of its aggressive feeding habits"
	],
	"Bluegill" : [
		"Despite the blugill's name, its gills are actually yellow! They've been playing us for fools....",
		"Once the bluegill's nest is established, the males will strongly defend it against threats"
	],
	"Bowfin" : [
		"Originally bowfins were used to play stringed instruments until the bowstring was invented",
	],
	"Carp" : [
		"What the carp?!",
		"Carps have a thick leathery appearance, and use their naturally tough skin to live up to 40 years!"
	],
	"Catfish" : [
		"Mroww >.<\n   -catfish, probably",
		"Catfish are in fact, not cats in a fish costume. However, cats are fish in a cat costume- they use the disguise to draw suspicion away from their cooperation with the axolotls",
		"Catfish have taste buds all over their body, making them like ~swimming tongues~"
	],
	"Clownfish" : [
		"Maybe the real Nemo was the friends we made along the way",
		"This isnt a clownfish, it's the whole circus",
		"Clownfish are all born male, and some later change into females"
	],
	"Coelacanth" : [
		"The freek is this thing ??",
		"Coelacanth are just evolved bluefish",
		"The coelacanth's jaws are formed in a unique way to allow them to open very wide"
	],
	"Crab" : [
		"The ultimate form of evolution is the crab. Accept the inevitable- become crab today!",
		"Why was the crustation having a bad day? It was feeling crabby :(",
		"Crabs have teeth in their stomachs"
	],
	"Crappie" : [
		"Whoever named the crappie must have been having a really bad day",
		"Crappies are nest builders, generally nesting in the spring when water temperatures are warm"
	],
	"Crayfish" : [
		"Shockingly, the \"cray\"-fish isn't actually crazy, at least not verifiably",
		"Crayfish are excellent diggers, making their own tunnels that they use for shelter and escape from predators"
	],
	"Drum" : [
		"Drummy drum drum fish",
		"At all times, the drumfish has 4 on the floor",
		"Unfortunately, the drumfish doesn't know breakbeat",
		"Drum fish are also called \"drums\" or \"croakers\" because of the sound they make with their swimming bladders"
	],
	"Eel" : [
		"eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeel!!",
		"eeeeEEEl?",
		"el.",
		"eeeEEEEEeeeEEEEAAAALLLL!"
	],
	"Flounder" : [
		"This fishy was never good at anything, it was too busy floundering about",
		"Flounders are born with both eyes on one side of it's head"
	],
	"Gar" : [
		"The gar fish is named after gary, the guy who found them",
		"Gars are an anchient species of fish that have been around for over 100 million years"
	],
	"Golden_Bass" : [
		"d-d-d-d-d-d-d-d-d-d-d-d-drop the bass BWOW MROW BU-BU-BU-BU-BU-BU-BU-BU NRWOUUUUH",
	],
	"Goldfish" : [
		"Goldfish actually have pretty good memories. Please stop bullying them about it.",
		"While the goldfish is not made of gold, it most certainly lives up to the fish in its name",
		"Goldfish actually taste with their lips- not their tongue"
	],
	"Great_White_Shark" : [
		"The great white shark? More like the LAME white shark!!",
		"The great white shark are born hunters, they can immediately hunt for prey after birth."
	],
	"Grouper" : [
		"The grouper has anti-social anxiety",
		"Groupers can live up to 50 flippin years"
	],
	"Guppy" : [
		"Gloppy glup glup -Guppy",
		"The guppy has the cutest name of any fishey, fite me",
		"Guppies are often called \"millions fish\" because of their incredible breeding rate "
	],
	"Hammerhead_Shark" : [
		"Looks like the hammer(head) just found a nail!!!",
		"The hammerhead shark was a rare creature on this planet and it had been seen before the time it had become extinct and the shark had become so popular in Europe as a symbol of its size it was considered extinct and it was thought to have died in its natural appearance in some parts and was later discovered as a species of fish that had been known for long and short periods in the past and now live on the islands in South America",
		"The hammerhead likes to eat small fish, stingrays, and octopus"
	],
	"Helicoprion" : [
		"What the flip is that thing",
		"The helicoprion was a massive monstrosity - it weighed up to half a ton and was 20–25 feet long",
		"Cosmic horrors are afraid of this thing"
	],
	"Herring" : [
		"The herring is a devious critter that will leave you both clueless AND maidenless",
		"What happened to the fisherman at the rock concert? He lost his herring!!",
		"Herrings form massive schools, sometimes containing billions of fishies"
	],
	"Horseshoe_Crab" : [
		"The horseshoe crab's blue blood is worth more than gold, about $60,000 per gallon, and is mostly used for vaccine research",
		"Despite the name, horseshoe crabs are not actually crustaceans- they're more closely related to arachnids"
	],
	"Koi" : [
		"The koi is just an overgrown guppy",
		"Koi fish are very secretive and good at playing hard-to-get",
		"Koi are an especially intellegent species of fish"
	],
	"Krill" : [
		"This small fish may look harmless, but the second you turn your back it goes for the krill",
		"Need algae removed? Sounds like a krill issue...",
		"Krill have a survival mechanism called regression, where they shrink in size and reabsorb their own sexual organs during food shortages"
	],
	"Largemouth_Bass" : [
		"Adult largemouth bass are the top predators in the aquatic ecosystem",
	],
	"Leech" : [
		"leeches, leeches, leeches, leeches, leeches, leeches, leeches, leeches, leeches, leeches, leeches, leeches, MUSHROOM, MUSHROOM!!!",
		"I relate a lot to leeches because I feind for the blood of my enemies (everyone)",
		"Leeches were the primary tool for blood-letting in the middle ages"
	],
	"Leedsichthys" : [
		"The leedsichthys had over 40,000 teeth",
		"The leedsichthys most likely would have had to shed the giant filter plates located at the back of its mouth in order to keep them clean",
		"After sheading its giant filter plates at the back of its mouth, the leedsichthys wouldnt have been able to eat for arround two weeks"
	],
	"Lionfish" : [
		"I'd be lion if I said I wasn't fishin'",
		"Despite the name, lionfish aren't actually lions",
		"Lionfish can expand their stomachs up to 30x their normal size when eating a large meal"
	],
	"Marlin" : [
		"Marlin, the court wizard to king salmon!",
		"The Marlin are among the fastest fish in the ocean"
	],
	"Mooneye" : [
		"Mooneye are very hyperactive, and strong fighters!",
	],
	"Muskellunge" : [
		"Get real, no one is pronouncing \"muskellunge\" correctly- it's \"muskellunge\", not \"muskellunge\"",
		"Muskellunge are stealthy ambush predators, often hunting near submerged weeds and logs"
	],
	"Octopus" : [
		"The octopus knows where it is by dividing where it was by where it isnt, and where it isnt from where it is. It's elementary, really.",
		"2/3 of the octopus' neurons are located in their arms, not their brain"
	],
	"Oyster" : [
		"Oyster?? I hardly know 'er!",
		"I don't really belive that oysters have pearls, that sounds kinda dumb tbh.."
	],
	"Perch" : [
		"The perch is named that way because of the way it \"perches\" on coral to observe its prey like a vulture",
		"Perch often school together by size and age, forming spindle-shaped formations"
	],
	"Pike" : [
		"Pikes use their hardened foreheads to pierce through their enemy's shield and stab their heart",
		"Pike specialise in ambush hunting, studies show that they can learn from failed hunting attempts and change their strategies to better catch new fish"
	],
	"Pupfish" : [
		"awrufff RUFF arrrrrr grrr... AWOOOO rufff ruff..",
		"Why's he lookin at u like that...",
		"Pupfish evolve dramatically in just a few generations- entire subspecies can evolve one year, and go extinct the next"
	],
	"Rainbow_Trout" : [
		"It's a double rainbow! (trout)",
		"As juveniles, rainbow trout imprint the smell of their natal stream into their brain, locking in a chemical signature they’ll use to return years later"
	],
	"Salmon" : [
		"His name's salmon, but you can just call him sal for short",
		"If you think about it, maybe the real salmon was the friends we made along the way",
		"Salmon have an extremely keen sense of smell – they can smell chemicals down to one part per million"
	],
	"Sawfish" : [
		"The sawfish is probably what sawed that boat in half",
		"Shockingly, the wood saw is named after the sawfish, due to their physical similarities",
		"Sawfish are 100% real, and the actually look like that"
	],
	"Seahorse" : [
		"You've heard of horse girls, now get ready for seahorse-girls: the next big thing",
		"Seahorses are made fun of by fellow fishies because they cant swim very fast",
		"The seahorse's curly tail can grasp is used to anchor themselves to underwater vegiation"
	],
	"Sea_Turtle" : [
		"Sea turtles are a lot like regular turtles but they are in the sea, more at 11",
		"Sea turtles can detect variations in Earth's magnetic field and use it like a GPS to navigate thousands of kilometers"
	],
	"Shrimp" : [
		"That's shrimply resharkable",
		"The fact is, we live in a shrimpulation- that is a world run by our shrimply shrimptacular shrimp overlords",
		"A shrimp's heart is located in their head"
	],
	"Snail" : [
		"A snail can actually travel really really fast if you throw it",
		"Please don't throw the snail",
		"Snails never \"switch\" shells, they stick with only one for life"
	],
	"Squid" : [
		"They added the squid from minecraft to real life!!",
		"Colossal squids are the largest invertebrate on earth, they are absolutely terrifying"
	],
	"Sting_Ray" : [
		"The australians are still salty about the stingray",
		"Stingrays have a unique sensory system called \"electroreception,\" which gives them the ability to sense or perceive electric fields, such as those generated by prey"
	],
	"Sturgeon" : [
		"Do NOT let this lil guy give you open heart surgery",
		"The sturgeon is an expert in typosquatting",
		"Sturgeons are carnivorous predators, but they have no teeth, instead, they suck their food in like a vacuum"
	],
	"Sunfish" : [
		"Ocean sunfish eat almost exclusively jellyfish",
	],
	"Toad" : [
		"The toad says ur princess is in another castle.. sry...",
		"Surfs up dude! This lil guy is toad-ally tubular",
		"Toads don't have the sticky tounges of frogs, instead the have to plop over to eat their prey"
	],
	"Tuna" : [
		"Can a tuna fish? No, but a tin can!",
		"Don't worry, there's a tuna fish in the sea!",
		"Tuna?? What happened to onea?!",
		"Theoretically, it is possible to tuna fish.",
		"Fortunately, there's a tuuuuna fish puns I can come up with",
		"Tuna rely on continuous forward motion to breathe"
	],
	"Turtle" : [
		"\"Turtle\" Said the wise tortoise",
		"Turtles survived the asteroid that killed the dinosaurs"
	],
	"Walleye" : [
		"The walleye is small, smooth, sleak, slipery, slimy, and slick",
		"The walleye's name comes from their large, reflective eyes"
	],
	"Whale" : [
		"Whales are pretty smart, they just go straight for the krill",
		"Blue whales are the largest animals on Earth",
		"In relaxation, a blue whale's heartrate can be as low as 2 times per minuite",
		"A Sperm whale's vocalizations are so loud that they can not only deafen, but also immediately kill any unlucky nearby divers"
	],
	"Wolffish" : [
		"This guy is absoulutely mortified",
		"The wolf fish shares it's profound wisdom:\nAWOOOOO aw aw AWOOOOOO",
		"The wolf fish has strong, crushing teeth and powerful jaws"
	],
}
const FACT_TIME = 20.0

var avalable_fish := []
var selected_fish : String
var selected_fact : String

func choose_new_fish():
	if avalable_fish.size() == 0:
		avalable_fish = FISHIES.keys().duplicate()
		avalable_fish.shuffle()
	
	selected_fish = avalable_fish.pop_front()
	selected_fact = FACTS[selected_fish].pick_random()
	fact.text = selected_fact
	texture.texture = FISHIES[selected_fish]

func _ready() -> void:
	animation_player.play("fade_in", -1, 0.0, true)
	await get_tree().create_timer(5.0).timeout
	for i in 1000:
		choose_new_fish()
		animation_player.play("fade_in", -1, -1.0, true)
		await get_tree().create_timer(FACT_TIME).timeout
		animation_player.play("fade_in", -1, 1.0)
		
		await get_tree().create_timer(1.0).timeout
		
