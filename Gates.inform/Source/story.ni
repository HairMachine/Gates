"Gates" by S R Williams

[DATA]

Table of Leads
Address	First Name	Last Name	Skill	Difficulty	Information
"ND-12"	"Bob"	"Jones"	"Persuasion"	30	"I know the code fragment A1 is at position 10"
"SD-14"	"Belinda"	"Speck"	"Fighting"	45	"I know the code fragment D6 is at position 4"
"ED-67"	"Emily"	"Yang"	""	0	"Bob Jones has family that lives in the North District, between block 10 and 15 I think"
"WD-80"	"Jim"	"Juke"	"Persuasion"	75	"Last I knew, Belinda Speck was hiding in SD-14"

Table of Monster Stats
Name	Fighting	Toughness	HP	Morale
"Gark"	20	15	2	10
"Commander Gark"	30	15	3	25	

The list of first names is a list of texts that varies. The list of first names is {"Bob", "Belinda", "Emily", "Jane", "Andrew", "Graham"}.
The list of last names is a list of texts that varies. The list of last names is {"Jones", "Speck", "Yang", "Juke", "Short", "Plotkin"}.
The enemy's crystals is a number that varies. The enemy's crystals is 10.
The player's crystals is a number that varies. The player's crystals is 0.

[PHRASES]

To decide if (skill a - a number) beats (skill b - a number):
	let aRoll be a random number from 1 to 100;
	let bRoll be a random number from 1 to 100;
	let aTot be skill a - aRoll;
	let bTot be skill b - bRoll;
	if aTot is less than bTot:
		decide on false;
	otherwise:
		decide on true.
	
[ACTIONS]

Getting Help is an action applying to nothing. Understand "help" as getting help.
Carry out getting help:
	say "Type 'i' or 'inventory' to see the list of items you are carrying. To interact with an object, you can generally type 'use object' to do so; if you have to be more specific than this, the game will tell you.[paragraph break]Walk around town using the directions north, east, south and west. If you get into a cab, use 'go to address' instead, where address is a valid address name, and the driver will take you there. Use ' go to city centre' to return from the districts.[paragraph break]Type 'get object' or 'pick up object' to pick something up and add it to your inventory.[paragraph break]Type 'search' or 'investigate' to spend time searching through an area for something or someone you think should be nearby.[paragraph break]Type 'confront name' to 'talk to name' to interact with someone.[paragraph break]Type 'examine object' or 'x object' to take a closer look at something."

Using is an action applying to one thing. Understand "use [thing]" as using.
Carry out using:
	say "You don't know what to do with [the noun]."

Going to is an action applying to one topic. Understand "go [text]" and "go to [text]" as going to.
Carry out going to:
	say "You talk to the wind. But the wind does not hear; the wind cannot hear.".
	
Investigating is an action applying to nothing. Understand "search" and "investigate" as investigating.
Carry out investigating:
	if the current address is an Address listed in the Table of Leads:
		choose row with Address of current address in the Table of Leads;
		now the dummy is in the Urban Sprawl;
		now the printed name of the dummy is "[first name entry] [last name entry]";
		now the firstName of the dummy is "[first name entry]";
		now the lastName of the dummy is "[last name entry]";
		now the dummy is proper-named;
		if "[skill entry]" is "Persuasion":
			now the Persuasion of the dummy is the difficulty entry;
		else if "[skill entry]" is "Fighting":
			now the Fighting of the dummy is the difficulty entry;
		say "You thoroughly search the area. You have found [the dummy]!";
		now the Information of the dummy is the information entry;
	otherwise:
		say "You thoroughly search the area, but come up empy handed."
		
[TODO: This should be broken up into separate persuade and confront actions - you have to use the right one to get a good result.]
Confronting is an action applying to one thing. Understand "confront [person]" and "talk to [person]" as confronting.
Carry out confronting:
	if the noun is not the player and the noun is not a driver:
		if the persuasion of the noun is greater than 0:
			if the persuasion of the player beats the persuasion of the noun:	
				say "You persuade [firstName of the dummy]!";
				say "'OK, I guess... [information of the noun]'.";
			otherwise:
				say "You fail to persuade [firstName of the noun]. They walk away, looking agitated.";
				remove the dummy from play;
		else if the fighting of the noun is greater than 0:
			if the fighting of the player beats the fighting of the noun:
				say "You beat up [firstName of the noun]!";
				say "OK, OK! '[information of the noun]'.";
			otherwise:
				say "You are beaten up by [firstName of the noun]. They get away!";
				remove the dummy from play;
		otherwise:
			say "[firstName of the noun] is happy to talk to you.";
			say "'[information of the noun]'.";
	otherwise:
		say "You angrily berate [the noun], but it doesn't make any difference.";
		
Battling is an action applying to one thing. Understand "fight [monster]", "battle [monster]" and "attack [monster]" as Battling.
Carry out Battling:
	say "You fight [the noun]!";
	if the fighting of the player beats the toughness of the noun:
		say "You hit!";
		now the HP of the noun is the HP of the noun - 1;
		if the HP of the noun <= 0:
			if the size of the noun > 1:
				say "One of [the noun] falls, leaving [size of the noun - 1]!";
				now the size of the noun is the size of the noun - 1;
				now the hp of the noun is the max hp of the noun;
				now incursionMorale is incursionMorale - morale of the noun;	
				if incursionMorale < incursionMoraleMax / 2:
					now incursionOngoing is 2;
			otherwise:
				remove the noun from play;
				say "[The noun] has been defeated!";
	otherwise:
		say "You fail to harm [the noun]."

After Battling or using:
	repeat with item running through visible monsters:
		say "The [item] attacks!";
		if the fighting of the item beats the toughness of the player:
			say "You are wounded!";
			now the HP of the player is the HP of the player - 1;
		otherwise:
			say "You shrug off the blow.";
		if the HP of the player <= 0:
			end the story saying "You have died".
			
Paying is an action applying to nothing. Understand "pay" and "purchase" as Paying.
Carry out Paying:
	if a shopkeeper is visible:
		if money owed > 0:
			say "You exchange $[money owed] for the items. The shopkeeper rubs their hands greedily.";
			now money owed is 0;
		otherwise:
			say "You've got nothing to buy!".

Mining is an action applying to nothing. Understand "mine" and "explore" as Mining.
Carry out Mining:
	if the player is in a mine:
		say "You enter the opening and descend into the darkness. Outside of the tiny illuminated sphere of your flickering yellow lamp light, it is pitck dark.";
		if the crystals of the location of the player > 0:
			let C be a random number from 1 to the crystals of the location of the player;
			say "After some time, you detect the strange ethereal glow of your quarry ahead! You dig out the cache, taking [C] crystals.";
			now the player's crystals is the player's crystals + C;
			now the crystals of the location of the player is the crystals of the location of the player - C;
		otherwise:
			say "You wander the caverns, but can find nothing of interest. You return to the daylight.";
	otherwise:
		say "If you want to mine, better go to a mine eh?"

Selling is an action applying to nothing. Understand "sell" and "sell crystals" as Selling.
Carry out Selling:
	if the player is in the Prospector's Guild:
		if the player's crystals > 0:
			let M be the player's crystals * 2;
			say "You show your haul to the teller. After some haggling, she agrees to take the crystals off your hands for $[M]. You shake hands on the deal and take the cash; she wraps the crystals in crystallite and stashes them in a safe behind the counter.";
			now the player's crystals is 0;
			[TODO: Actually pay the player. Also crystals should be handled like money.]
		otherwise:
			say "You don't have any crystals to sell.";
	otherwise:
		say "You can't do that here.".

[THINGS]

A driver is a kind of person.
A cab is a kind of vehicle. In every cab is a driver.
The current address is text which varies.
After entering a cab, say "You climb into the cab. The driver says, 'Where to?'"
Instead of going somewhere while the player is inside a cab, say "You'd better get out first!"
Instead of going to while the player is inside a cab:
	if the topic understood matches the regular expression "<NESW>D-<0-9><0-9>$":
		say "'Sure!' The cab moves off. After a time, the cab pulls up at your destination. You pay the driver and get out.";
		now the persuasion of the dummy is 0;
		now the fighting of the dummy is 0;
		now the information of the dummy is "";
		remove the dummy from play;
		now the current address is the substituted form of "[the topic understood]";
		now the player is in the Urban Sprawl;
	else if the topic understood matches "city centre" or the topic understood matches "city" or the topic understood matches "city center" or the topic understood matches "home":
		say "'Sure!' The cab returns to the centre of town. You pay the driver and get out.";
		[TODO: We can be fancy and check the current address value to return to the correct point, but probably will add the ability to "hail" a cab as an action instead, which summons a cab to your location rather than having specific locations.]
		now the player is in the Northern District;
		now the current address is "";
	else if the topic understood matches "mine" or the topic understood matches "crystal mine":
		say "'Sure!' The cab drives off. After a time it arrives at the mine on the outskirts of the city. You pay the driver and get out.";
		now the player is in the Crystal Mine;
		now the current address is "";
	otherwise:
		say "'Sorry, I don't know where that is.'".
		
Figure of MapImage is the file "TownMap.png".
The map is a thing.
Instead of using or examining the map, display the Figure of MapImage.

The notebook is a thing.
Instead of using or examining the notebook, say "You check your notebook."

An item is a kind of thing. Items have a number called cost.

A derringer is an item.
A derringer has cost 10.
After taking a derringer, now the Fighting of the player is the Fighting of the player + 5.
After dropping a derringer, now the Fighting of the player is the Fighting of the player - 5.

A shotgun is an item.
A shotgun has cost 18.
After taking a shotgun, now the Fighting of the player is the Fighting of the player + 10.
After dropping a shotgun, now the Fighting of the player is the Fighting of the player - 10.

A magnifying glass is an item.
A magnifying glass has cost 6.
After taking a magnifying glass, now the Investigation of the player is the Investigation of the player + 5.
After dropping a magnifying glass, now the Investigation of the player is the Investigation of the player - 5.

[TODO: Figure out how to add a nice time display to the scanner]
The incursion scanner is a thing.
The incursion scanner has a text called display.
The incursion scanner has a list of texts called targets. Targets is {"BlingCorp Bank", "ZingCorp Bank", "DingCorp Bank", "PringCorp Bank", "Minor Bank 1","Minor Bank 2", "Minor Bank 3", "Minor Bank 4"}.
The description of the incursion scanner is "A bulbous metal device, with apparently random wires sticking out of it and connecting to other parts. A copper billboard display, hundreds of tiny panels bearing letters and numbers, show the messages. A faint crystal luminesence glimmers in the gaps."
Instead of using the incursion scanner, say "The display reads [display of the incursion scanner]."
At the time when the incursion scanner pings: 
	say "Your incursion scanner lets out a ringing chime. Its timer is 0, and its display reads [display of the incursion scanner]. A red light comes on.";
	now incursionOngoing is 1.

A person has some indexed text called firstName.
A person has some indexed text called lastName.
A person has a number called Fighting.
A person has a number called Persuasion.
A person has a number called Investigation.
A person has a number called Willpower.
A person has a number called Toughness.
A person has some text called Information.
A person has a number called HP.
A person has a number called max HP.
A person has a number called Morale.
Understand the firstName property as describing a person.
Understand the lastName property as describing a person.
The dummy is a person.

A mob is a kind of person.
A mob has a number called size.
Rule for printing the name of a mob:
	if the size of the noun > 1:
		say "group of [size] [firstName]s";
	otherwise:
		say "[a firstName]".

A monster is a kind of mob.
The monsterOne is a monster.
The monsterTwo is a monster.
The monsterThree is a monster.
The monsterFour is a monster.
The monsterFive is a monster.

A defender is a kind of mob.
The defenderOne is a defender.
The defenderTwo is a defender.
The defenderThree is a defender.
The defenderFour is a defender.
The defenderFive is a defender.

A shopkeeper is a kind of person.

A bank is a kind of room. A bank has a number called crystals.
A mine is a kind of room. A mine has a number called crystals.

[ROOMS]

The Archives is a room. "A marble monument to knowledge. DingCorp Bank is to the north, the Hospital to the west, Silver Rush to the south and the Job Centre to the east."
The research device is in the Archives. The description of the research device is "A desk covered in an array of brass tubules and an addressable spring-loaded typeboard for requesting information from the archive. The system you know is mostly pneumatic, but augmented with some crystal technology here and there. With a few presses you can summon printed information from anywhere in the Archive's stygian depths."
Instead of using the research device:
	say "You sit down and begin to check the records. Time passes as you fall into your task, the clacking of the typeboard and the whoosh of arriving papers sinking into your subconcious.[paragraph break]You sit back for a break. Nothing so far."

DingCorp Bank is a bank. It is north of the Archives. The crystals of it is 5.  "An imposing corporate edifice. The Northern district sprawls to the north of here, while the Archives lie to the south."

The Northern District is north of DingCorp Bank. "A vast maze of blocks stretching for miles, the Northern District is clean and green and houses the more affluent elements of the city. To the south is the impressive facde of DingCorp Bank." Here is a cab.

The Hospital is west of the Archives. "St. Clemens Hospital is a relatively modern construction. To the north lies PringCorp Bank, while a minor bank is to the south. The Archives lie east."
The doctor is a person in the hospital.
Instead of confronting the doctor:
	if the HP of the player < the max HP of the player:
		say "You talk the doctor. They patch you up.";
		now the HP of the player is the max HP of the player;
	otherwise:
		say "You don't need to see the doctor."

PringCorp Bank is a bank. It is north of the Hospital. The crystals of it is 5.  "An austere brick block of a building. To the west sprawls the Western District, to the south the Hospital"

The Western District is west of PringCorp Bank. "Colourful and vibrant, the Western District is deprived in wealth but rich in culture. To the east lies the brick block of PringCorp bank." Here is a cab.

Minor Bank 1 is a bank. It is south of the Hospital. The crystals of it is 2.  "A drab and beaurocratic affair, with a sign that reads 'Clemens and Co.'. To the north lies the Hospital."

Money owed is a number that varies. Money owed is 0.
Silver Rush is south of the Archives. "This unassuming place is not to be underestimated - it contains a huge collection of the latest gadgets and you can usually find a good deal. Burly guards lounge threateningly. To the north lies the sparkling marble of the Archives, to the south the spire of ZingCorp Bank."
The counter is in the Silver Rush. On the counter are a shotgun, a derringer and a magnifying glass.
After taking an item in the Silver Rush: 
	now money owed is money owed + the cost of the noun;
	say "Taken."
After putting something on the counter:
	now money owed is money owed - the cost of the noun;
	say "You replace [the noun]."
Instead of going somewhere when money owed > 0, say "A burly guard nonchalantly moves to block your exit. 'You gonna pay for that or what?'"
Instead of dropping something in the Silver Rush, say "You don't think they'd take kindly to littering here."
The attendant is a shopkeeper in the Silver Rush.
The burly guard is a person in the Silver Rush. The burly guard is scenery. "The guards loom burly and bored - a dangerous combination."

ZingCorp Bank is a bank. It is south of Silver Rush. The crystals of it is 5. "A twisting spire of some kind of black stone, this place is often referred to as the wizard's tower because of the affectations of the self-styled Grand Master Zing who runs it. To the north likes Silver Rush, to the south spreads the South District."

The Southern District is south of ZingCorp Bank. "A modern district, this urban sprawl is largely home to the middle professional class - those of the crisp suit, the anonymous hat, and the briefcase full of dull papers. To the north is the blackened spire of ZingCorp bank." Here is a cab.

Job Centre is east of the Archives. "A squat block, this place is the place where protifable business actions are transacted - for a fee, of course. The the west lies the Archives, to the north the Prospector's Guild, to the south the Training complex, and to the east a minor bank."

Minor Bank 2 is a bank. It is east of the Job Centre. The crystals of it is 2. "An unassuming brick co-operative. To the west is the Job Centre."

The Prospector's Guild is north of the Job Centre. "A somewhat ramshackle affair that belies the incredible wealth that the guild controls. In some sense, all of the city revolves around this place. To the south is the Job Cenre, while to the east is a minor bank."
The sell sign is here. "On the wall a battered sign exclaims 'Exchange crystals for ready cash! Great rates available!'". The sell sign is fixed in place.
The teller is here. The teller is a person. The description of the teller is "She looks at you appraisingly through her monocle."

Minor Bank 3 is a bank. It is east of the Prospector's Guild. The crystals of it is 2. "A neat whitewashed building, likely run by a successful dentist or similar. To the west lies the Prospector's Guild, while to the north glitters the BlingCorp Bank."

BlingCorp Bank is a bank. It is north of Minor Bank 2. The crystals of it is 5. "This baroque structure is bedecked with gold leaf and statues of various important persons in attitudes of important business, straddling the line between gaudy and magnificent. To the south is a much humbler minor bank, while to the east the Eastern District sprawls over the hills."

The Eastern District is east of BlingCorp Bank. "Winding sinuously up into the hills that formerly were outside the town, the eastern district is largely middle class, and has absorbed several older villages. To the east is the grand BlingCorp Bank." Here is a cab.

Training is south of the Job Centre. "The foremost self-improvement place in the city, the simply-named Training has numerous instructors, courses and apparatues ready to test and extend your skills and knowledge - for a fee, of course. To the north lies the Job Centre, to the east a minor bank."
The training desk is here. Understand "desk" as the training desk. The printed name of the training desk is "a desk". On the training desk is the course book.
Instead of examining the course book:
	say "You leaf through the course book, wincing slightly. Well, nobody said education was cheap."
Instead of taking the course book:
	say "This belongs where it is."

Minor Bank 4 is a bank. It is east of Training. The crystals of it is 2.  "A featureless concrete block, both inside and out. To the north is Training."

The Crystal Mine is a mine. "A rent in the earth disapears into a darkness ahead of you, leading into an underground labyrinth. Precious crystals are here for the taking." Here is a cab.

Urban Sprawl is a room. "You are deep within the maze of urban life,. A sign nearby reads [current address]."
Instead of going somewhere when the player is in the Urban Sprawl, say "Best catch a cab, or you'll be wandering for hours."
Here is a cab.

[SCENES]

IncursionOngoing is a number that varies. IncursionOngoing is 0.
IncursionMorale is a number that varies. IncursionMorale is 0.
IncursionMoraleMax is a number that varies. IncursionMoraleMax is 0.
DefenderMorale is a number that varies. DefenderMorale is 0.
DefenderMoraleMax is a number that varies. DefenderMoraleMax is 0.
Invasion is a recurring scene.
Invasion begins when incursionOngoing is 1.
Invasion ends when incursionOngoing is not 1.
The heist target is a bank that varies.
When Invasion begins:
	let M be a random number between 1 and the number of rows in the Table of Monster Stats;
	choose row M in the Table of Monster Stats;
	now the HP of monsterOne is the HP entry;
	now the max HP of monsterOne is the HP entry;
	now the printed name of monsterOne is the name entry;
	now the firstName of monsterOne is the name entry;
	[TODO: Group size not determined in this random way, should be drawn from the AI resource pool]
	now the size of monsterOne is a random number between 2 and 6;
	now the morale of monsterOne is the morale entry;
	now the fighting of monsterOne is the fighting entry;
	now the toughness of monsterOne is the toughness entry;
	now incursionMorale is the morale of monsterOne * the size of monsterOne;
	now incursionMoraleMax is incursionMorale;
	repeat with B running through all banks:
		if the display of the incursion scanner is "[the B]":
			now the heist target is B;
	now monsterOne is in the heist target;
	if a monster is visible:
		say "With a strange wrenching motion, things appear to unfold from thin air! They drop to the ground, gargling, and rush towards the vault.";
	if defenderMorale is 0 and no monsters are visible:
		now incursionOngoing is 0.
Every turn during Invasion:
	[TODO: Here the monsters fight defenders.]
	if defenderMorale is 0 and no monsters are visible:
		now incursionOngoing is 0.
When Invasion ends:
	if incursionOngoing is 0:
		if a monster is visible:
			say "The monsters shove past you into the vault. Hooting triumphantly, they stuff their sacks full of crystals and, with an eye-wrenching twist in space, fold up into nothing and vanish.";
		[TODO: Improve]
		let the stolen crystals be the size of monsterOne;
		if the crystals of the heist target is less than the stolen crystals, now the stolen crystals is the crystals of the heist target;
		now the crystals of the heist target is the crystals of the heist target - the stolen crystals;
		now the enemy's crystals is the enemy's crystals + the stolen crystals;
	if incursionOngoing is 2:
		if a monster is visible:
			say "Clucking wildly, the monsters retreat in disarray. With an eye-wrenching twist in space, they fold up into nothing and vanish.";
	say "The red light on your scanner blinks out suddenly.";
	if the enemy's crystals > 15:
		end the story saying "The enemy has stolen all of the crystals!";
	otherwise:
		remove monsterOne from play;
		now incursionOngoing is 0.

[EVENTS]

When play begins:
	say "This is the introduction text. Type 'help' to see the game rules and instructions.";
	now the player has the map;
	now the player has the notebook;
	now the player has the incursion scanner;
	now the Fighting of the player is 30;
	now the Persuasion of the player is 30;
	now the Investigation of the player is 30;
	now the Willpower of the player is 30;
	now the Toughness of the player is 30;
	now the HP of the player is 10;
	now the max HP of the player is 10;
	the enemy acts in 20 minutes from now;
	now the crystals of the Crystal Mine is 8;
	crystals generate in 10 minutes from now;
	banks gain crystals in 12 minutes from now;
	
At the time when the enemy acts:
	let R be a random number between 1 and the number of entries in the targets of the incursion scanner;
	now the display of the incursion scanner is entry R of the targets of the incursion scanner;
	say "The incursion scanner lets out a warning clang. The display updates. Its timer now shows 06:00 and its display reads [display of the incursion scanner].";
	the incursion scanner pings in six minutes from now;
	the enemy acts in 20 minutes from now.
	
At the time when crystals generate:
	let C be a random number between 1 and 4;
	now the crystals of the Crystal Mine is the crystals of the Crystal Mine + C;
	crystals generate in 10 minutes from now.
	
At the time when banks gain crystals:
	repeat with B running through banks:
		let C be a random number between 1 and 4;
		now the crystals of B is the crystals of B + C;
		banks gain crystals in 12 minutes from now.


[HOUSEKEEPING]

Release along with an interpreter.
		