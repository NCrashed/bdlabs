// Written in D programming language
/*
Boost Software License - Version 1.0 - August 17th, 2003

Permission is hereby granted, free of charge, to any person or organization
obtaining a copy of the software and accompanying documentation covered by
this license (the "Software") to use, reproduce, display, distribute,
execute, and transmit the Software, and to prepare derivative works of the
Software, and to permit third-parties to whom the Software is furnished to
do so, all subject to the following:

The copyright notices in the Software and this entire statement, including
the above license grant, this restriction and the following disclaimer,
must be included in all copies of the Software, in whole or in part, and
all derivative works of the Software, unless such copies or derivative
works are solely in the form of machine-executable object code generated by
a source language processor.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
*/
module data.generator;

import data.wrapper;
import data.structure;

public
{
	struct Generator 
	{
		SharksDB db;

		this(SharksDB db)
		{
			this.db = db;
		}


	}
}
private
{
	InformationSources[] sources = 
	[
		InformationSources(
			0,
			0,
			"International Shark Attack File",
			"http://www.flmnh.ufl.edu/fish/sharks/ISAF/ISAF.htm",
			"",
			true
		),
		InformationSources(
			1,
			0,
			"Global Shark Attack File",
			"http://www.sharkattackfile.net/",
			"",
			true
		),
		InformationSources(
			2,
			0,
			"Australian Shark Attack File",
			"http://www.taronga.org.au/tcsa/conservation-programs/australian-shark-attack-file/general-information.aspx",
			"",
			true
		),		
		InformationSources(
			3,
			0,
			"Australasian Shark Attack File",
			"http://www.shark.org.au/",
			"",
			true
		),
		InformationSources(
			4,
			0,
			"Shark Attack Survivors",
			"http://www.sharkattacksurvivors.com/",
			"",
			false
		),	
		InformationSources(
			5,
			0,
			"Shark attack information, statistics, and pictures",
			"http://www.sharkattackphotos.com/",
			"",
			false
		),	
		InformationSources(
			6,
			0,
			"Swim At Your Own Risk",
			"http://swimatyourownrisk.com/",
			"",
			false
		),	
	];

	string[] messages =
	[
`
A shark bit a 60-year-old surfer off Kauai’s west shore Wednesday, raising the attack total for Hawaii to 11 this year, an exceptionally active period for the ocean predators.

The strike on the Kalaheo man also was the second in six days in Hawaii.

The 11 attacks so far this year equal the total of the four previous years combined, according to figures from the state Department of Land and Natural Resources’ Division of Aquatic Resources.
`,
`
A 25-year-old surfer is expected to recover after being bitten by a shark in Humboldt County, authorities said.

The surfer was bitten shortly before noon Tuesday while surfing the North Jetty near Eureka Municipal Airport, the Humboldt County Sheriff’s Department said.

The surfer suffered a 14-inch wound and other injuries. He was loaded into a pickup truck by other surfers and taken to a hospital, authorities said.

“The victim had an approximate 14 inch bite wound and other wounds on his body that required surgery,” the Sheriff’s Department said in a statement.

The attack came after a 39-year-old surfer was killed last week after being bitten by an apparent great white shark while riding waves near Lompoc.
`,
`
Several Hawaii beaches were closed this weekend after a 51-year-old woman was attacked by a shark off the coast of Maui.
`,
`
A 39-year-old experienced surfer died Tuesday after a shark attack at an Air Force base beach in California, following months of frequent shark sightings along the coast.
Francisco Javier Solorio Jr., of Orcutt, was bitten in his upper torso while he was surfing with a friend who witnessed the attack.
They were in the ocean off the coastal Vandenberg Air Force Base, on Surf Beach in Lompoc, the Santa Barbara County sheriff’s department said in a statement.
`,
`
A man has been attacked by a shark off Western Australia’s Gascoyne coast on Tuesday afternoon The attack occurred while he was surfing at Red Bluff near Quobba Station, 70 kilometres north of Carnarvon. The break is about 1,000 kilometres north of Perth.

The 34-year-old man received serious injuries but was conscious when he was brought ashore. The Department of Fisheries says the shark bit the surfer on the abdomen and as he tried to fend it off he was then mauled on the arm.

Rebecca Caldwell’s children were in the water when they noticed the man was injured, but she says they did not see the shark.

“The water was full of blood,” she said.

“He was conscious the whole way back though he was OK, he was good.

“He’s in good spirits, as well as he could be.”

Carnarvon Shire chief executive Maurice Battilana says the beach has since been closed. He has told the ABC it is in a remote area that is very popular with tourists.

“Extremely popular surfing and camping spot and we’re probably in the peak season, very popular surfing spot,” he said.

Police and the St John Ambulance were sent to the location and the man has been taken to Carnarvon Hospital. The Royal Flying Doctor Service is flying its crew from Meekatharra to Carnarvon and they will then fly the man to Perth for treatment. The RFDS says the man has serious injuries to his right arm and is in a stable condition.

There have been five fatal shark attacks in less than a year off WA’s coast.
`,
`
A man has been attacked by a shark off Western Australia’s Gascoyne region, but is conscious as emergency services race to the remote location.

Police reported late on Tuesday that a person had been attacked by a shark about 200km south of Carnarvon, near Quobba Station.

The victim – believed to be a male surfer – suffered leg and abdominal injuries, but had been retrieved from the water and was conscious.

Emergency services are expected to take some time to attend the scene because it is a remote location.

“Initial reports suggest that the person is being conveyed by private car for assistance,” police said.

The Department of Fisheries was being sought for more information.

The attack comes six weeks after 24-year-old surfer Ben Linden was killed by a five metre great white shark some 160km north of Perth – the fifth fatal shark attack in WA waters in 10 months.
`,
`
Xavier Brunetiere, general secretary at the Reunion town hall, said the surfer’s right foot and his hand were seriously injured, in the attack at Saint Leu, located in a marine reserve on the western side of the island.
The man, whose identity was not released, is aged about 40 and is an experienced surfer, Brunetiere said.
Witnesses said the shark had severed a hand and a foot from the victim, but he made it back to the beach by himself. His life was not in danger, Brunetiere said.
Shark attacks here have been increasing in the last two years, with three surfers killed in the last 13 months.
Sunday’s attack, the third this year, comes just over a fortnight after 22-year-old local Alexandre Rassica was killed by a shark who bit off his leg.
`,
	];


	string[] caseDescriptions = [
		"Swimming",
		"Pearl diving",
		"Diving",
		"Swimming inside string of cedar logs",
		"Fishing",
		"Wading",
		"Wreck of  large double sailing canoe",
		"4 men were bathing",
		"Crew swimming alongside their anchored ship",
		"Swimming around anchored ship",
		"Swimming in pool formed by construction of a wharf",
		"Fishing, when sharks upset the boat",
		"Standing",
		"Sponge diving",
		"Wooden fishing boat",
		"Ship torpedoed, she was in the water awaiting rescue",
		"Aircraft ditched in the sea, swimming ashore",
		"Spent 8 days in dinghy",
		"Carrying a supposedly dead shark by its mouth",
		"Standing, washing rear wheels of his ambulance in ankle-deep water",
		"Fishing in ankle-deep water",
		"Free diving",
		"Floating on his back",
		"A group of survivors on a raft for 17-days",
		"Fishing, wading with string of fish",
		"Shark fishing, knocked overboard",
		"Lashing logs together when he fell into the water",
		"Testing movie camera in full diving dress",
		"Swimming with fish attached to  belt",
		"Spearfishing",
		"Swimming in section of river used for washing clothes & cooking utensils",
		"Fishing from a small boat & put his hand in the water while holding a dead fish",
		"Swimming from capsized pirogue",
		"Skindiving",
		"Diving for trochus",
		"Canoeing",
		"Free diving, collecting sand dollars",
		"Crossing river on a raft",
		"Scuba diving",
		"Skin diving. Grabbed shark's tail; shark turned & grabbed diver's ankle & began towing him to deep water",
		"Attempting to drive shark from area",
		"yachtsman in a zodiac",
		"Kitesurfing",
		"Scuba diving & feeding sharks",
		"Helmet diving",
		"Man fell overboard from ship. Those on board threw a rope to him with a wooden block & were pulling him to the ship",
		"Ship lay at anchor & man was working on its rudder"
	];	

	Places[] places = [
		Places(
			0,
			"Tricomalee",
			"CEYLON (SRI LANKA)",
			"Below the English fort",
			PlacesType.SHALLOW_WATER
		),
		Places(
			1,
			"North Carolina",
			"USA",
			"Ocracoke Inlet",
			PlacesType.SHALLOW_WATER
		),
		Places(
			2,
			"Western Australia",
			"AUSTRALIA",
			"Roebuck Bay",
			PlacesType.DEEP_WATER
		),
		Places(
			3,
			"Hawaii",
			"USA",
			"Puna",
			PlacesType.DEEP_WATER
		),
		Places(
			4,
			"KZN",
			"SOUTH AFRICA",
			"In front of the Beach Hotel, Durban",
			PlacesType.BEACH
		),		
		Places(
			5,
			"KZN",
			"SOUTH AFRICA",
			"Durban",
			PlacesType.SHALLOW_WATER
		),	
		Places(
			6,
			"North Carolina",
			"USA",
			"Somewhere between Hatteras and Beaufort",
			PlacesType.SHALLOW_WATER
		),
		Places(
			7,
			"Moala Island",
			"FIJI",
			"",
			PlacesType.DEEP_WATER
		),	
		Places(
			8,
			"Ba Ria-Vung Tau  province",
			"VIETNAM",
			"Vũng Tàu",
			PlacesType.DEEP_WATER
		),
		Places(
			9,
			"Florida",
			"USA",
			"Gadsden Point, Tampa Bay",
			PlacesType.SHALLOW_WATER
		),
		Places(
			10,
			"Queensland",
			"AUSTRALIA",
			"Great Barrier Reef",
			PlacesType.SHALLOW_WATER
		),
		Places(
			11,
			"St. Denis",
			"REUNION",
			"Barachois",
			PlacesType.BEACH
		),		
		Places(
			12,
			"Dodecanese Islands",
			"GREECE",
			"Symi Island",
			PlacesType.SHALLOW_WATER
		),		
		Places(
			13,
			"Adriatic Sea",
			"ITALY",
			"",
			PlacesType.DEEP_WATER
		),		
		Places(
			14,
			"Madang Province",
			"PAPUA NEW GUINEA",
			"Off Lae",
			PlacesType.DEEP_WATER
		),	
		Places(
			15,
			"Between New Ireland & New Britain",
			"PAPUA NEW GUINEA",
			"St. George’s Channel",
			PlacesType.DEEP_WATER
		),	
		Places(
			16,
			"Eastern Province",
			"SAUDI ARABIA",
			"East of the Ras Tanura-Jubail area",
			PlacesType.SHALLOW_WATER
		),	
		Places(
			17,
			"Basrah",
			"IRAQ",
			"Shatt-el Arab River near a small boat stand",
			PlacesType.BEACH
		),	
		Places(
			18,
			"Khuzestan Province",
			"IRAN",
			"Ahvaz, on the Karun River",
			PlacesType.RIVER
		),		
		Places(
			19,
			"Torres Strait",
			"AUSTRALIA",
			"Thursday Island",
			PlacesType.SHALLOW_WATER
		),	
		Places(
			20,
			"New Georgia",
			"SOLOMON ISLANDS",
			"Munda Island, Roviana Lagoon",
			PlacesType.BEACH
		),	
		Places(
			21,
			"Phoenix Islands",
			"KIRIBATI",
			"Canton Island",
			PlacesType.SHALLOW_WATER
		),
		Places(
			22,
			"La Havana Province",
			"CUBA",
			"Cojimar",
			PlacesType.SHALLOW_WATER
		),		
	];

	Reasons[] reasons = [
		Reasons(
			0,
			"Touching shark",
			"Human touches a shark, pokes it, teases it, spears, hooks, or nets it, or otherwise aggravates/provokes it in a certain manner",
			true
		),
		Reasons(
			1,
			"Catched shark",
			"Incidents that occur outside of a shark's natural habitat, e.g., aquariums and research holding-pens, are considered provoked, as are all incidents involving captured sharks.",
			true
		),	
		Reasons(
			2,
			"Accidentally provokation",
			"Sometimes humans inadvertently \"provoke\" an attack, such as when a surfer accidentally hits a shark with a surf board.",
			true
		),	
		Reasons(
			3,
			"Hit-and-run attack",
			"Usually non-fatal, the shark bites and then leaves; most victims do not see the shark. This is the most common type of attack and typically occurs in the surf zone or in murky water. Most hit-and-run attacks are believed to be the result of mistaken identity",
			false
		),	
		Reasons(
			4,
			"Sneak attack",
			"The victim will not usually see the shark, and may sustain multiple deep bites. This is the most fatal kind of attack and is not believed to be the result of mistaken identity.",
			false
		),	
		Reasons(
			5,
			"Bump-and-bite attack",
			"The shark circles and bumps the victim before biting. Repeated bites are not uncommon and can be severe or fatal. Bump-and-bite attacks are not believed to be the result of mistaken identity.[",
			false
		),
	];

	SharkSpieces[] spicies = [
		SharkSpieces(
			0,
			"Great white shark",
			"The great white shark, Carcharodon carcharias, also known as the great white, white pointer, white shark, or white death, is a species of large lamniform shark which can be found in the coastal surface waters of all the major oceans.",
			6,
			"Great white sharks are carnivorous and prey upon fish (e.g. tuna, rays, other sharks), cetaceans (i.e., dolphins, porpoises, whales), pinnipeds (e.g. seals, fur seals, and sea lions), sea turtles, sea otters, and seabirds.",
			"photos/White_shark.jpg",
			10
		),
		SharkSpieces(
			1,
			"Bull shark",
			"The bull shark, Carcharhinus leucas, also known as the Zambezi shark (UK: Zambesi shark) or unofficially Zambi in Africa and Nicaragua shark in Nicaragua, is a shark commonly found worldwide in warm, shallow waters along coasts and in rivers. The bull shark is known for its aggressive nature, predilection for warm shallow water, and presence in brackish and freshwater systems including estuaries and rivers.",
			1,
			"Bull sharks are typically solitary hunters, but occasionally hunt in pairs. They often cruise through shallow waters. They can accelerate rapidly and can be highly aggressive, even possibly attacking a racehorse in the Brisbane River in the Australian state of Queensland. They are extremely territorial and attack animals that enter their territory. Since bull sharks often dwell in very shallow waters, they may be more dangerous to humans than any other species of shark, and along with the tiger shark, oceanic whitetip and great white shark, are among the four shark species most likely to attack humans",
			"photos/Bull_shark.jpg",
			5
		),		
		SharkSpieces(
			2,
			"Tiger shark",
			"The tiger shark, Galeocerdo cuvier, is a species of requiem shark and the only member of the genus Galeocerdo. Commonly known as sea tiger, the tiger shark is a relatively large macropredator, capable of attaining a length of over 5 m (16 ft). It is found in many tropical and temperate waters, and it is especially common around central Pacific islands. Its name derives from the dark stripes down its body which resemble a tiger's pattern, which fade as the shark matures.",
			5,
			"The tiger shark is an apex predator and has a reputation for eating anything. Young tiger sharks are found to prey largely on small fish as well as various small jellyfish, cephalopods and other mollusks. Around the time they attain 2.3 m (7.5 ft), or near sexual maturity, their prey selection expands considerably and much larger animals become regular prey. Numerous fish, crustaceans, sea birds, sea snakes, marine mammals (e.g. bottlenose dolphins, spotted dolphins, dugongs, seals and sea lions), and sea turtles (including the three largest species: the green, the leatherback turtle and the loggerhead turtles) are regularly eaten by adult tiger sharks. The tiger shark also eats other sharks (including adult sandbar sharks), as well as rays, and will even eat conspecifics.",
			"photos/Tiger_shark.jpg",
			8
		),	
		SharkSpieces(
			3,
			"Oceanic whitetip shark",
			"The oceanic whitetip shark (Carcharhinus longimanus) is a large pelagic shark inhabiting tropical and warm temperate seas. Its stocky body is most notable for its long, white-tipped, rounded fins. This aggressive but slow-moving fish dominates feeding frenzies, and is a danger to shipwreck or air crash survivors. Recent studies show steeply declining populations because its large fins are highly valued as the chief ingredient of shark fin soup and, as with other shark species, the whitetip faces mounting fishing pressure throughout its range.",
			4,
			"C. longimanus feeds mainly on pelagic cephalopods and bony fish. However, its diet can be far more varied and less selective—it is known to eat threadfins, stingrays, sea turtles, birds, gastropods, crustaceans, and mammalian carrion. The bony fish it feeds on include lancetfish, oarfish, barracuda, jacks, dolphinfish, marlin, tuna, and mackerel. Its feeding methods include biting into groups of fish and swimming through schools of tuna with an open mouth. When feeding with other species, it becomes aggressive. Peter Benchley, author of Jaws, observed this shark swimming among pilot whales and eating their faeces.",
			"photos/Oceanic_Whitetip_Shark.png",
			8
		),
	];

	Habitats[] habitats = [
		Habitats(
			0,
			"Atlantic ocean",
			91660000,
			0.7
		),
		Habitats(
			1,
			"Indian ocean",
			73556000,
			0.8
		),	
		Habitats(
			2,
			"Pacific ocean",
			169200000,
			0.3
		),	
	];

	Property[] property = [
		Property(
			0,
			"Wooden fishing boat",
			3000,
			"Destroyed"
		),
		Property(
			1,
			"Fibreglass boat",
			14000,
			"Partial damage"
		),		
		Property(
			2,
			"Anchored  yacht",
			75000,
			"Partial damage"
		),	
		Property(
			3,
			"4.8-metre skiboat",
			20000,
			"Destroyed"
		),	
		Property(
			4,
			"Boat",
			1000,
			"Destroyed"
		),
		Property(
			5,
			"Ship",
			15000,
			"Partial damage"
		),
		Property(
			6,
			"Burke",
			17500,
			"Partial damage"
		),
	]
}