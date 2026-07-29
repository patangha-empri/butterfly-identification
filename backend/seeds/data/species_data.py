"""
Seed data for 50 Indian butterfly species.
Covers all major families found across India with accurate scientific data.
"""

# State codes for distribution mapping
ALL_STATES = [
    "AP", "AR", "AS", "BR", "CG", "GA", "GJ", "HR", "HP", "JH", "KA", "KL",
    "MP", "MH", "MN", "ML", "MZ", "NL", "OD", "PB", "RJ", "SK", "TN", "TS",
    "TR", "UP", "UK", "WB", "AN", "DL", "JK", "PY",
]
SOUTH_INDIA = ["AP", "KA", "KL", "TN", "TS", "PY", "GA"]
NORTHEAST = ["AR", "AS", "MN", "ML", "MZ", "NL", "SK", "TR", "WB"]
WESTERN_GHATS = ["KA", "KL", "TN", "MH", "GA"]
NORTH_INDIA = ["HR", "HP", "JK", "PB", "RJ", "UK", "UP", "DL", "BR", "JH"]
WIDESPREAD = ALL_STATES

BUTTERFLY_SPECIES = [
    # ══════════════════════════════════════════════════════════════════
    # FAMILY: Papilionidae (Swallowtails)
    # ══════════════════════════════════════════════════════════════════
    {
        "common_name": "Common Mormon",
        "scientific_name": "Papilio polytes",
        "family": "Papilionidae",
        "genus": "Papilio",
        "description": (
            "One of the most common and widespread swallowtails in India. "
            "Males are black with white spots along the wing margins. "
            "Females are polymorphic and mimic toxic species like the Common Rose and Crimson Rose."
        ),
        "habitat": "Gardens, forest edges, parks, urban areas, plantations",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 90,
        "wing_span_max_mm": 100,
        "is_migratory": False,
        "color_tags": ["black", "white", "red"],
        "host_plants": [
            {"plant_name": "Citrus", "plant_scientific_name": "Citrus spp."},
            {"plant_name": "Curry Leaf", "plant_scientific_name": "Murraya koenigii"},
            {"plant_name": "Lime", "plant_scientific_name": "Citrus aurantifolia"},
        ],
        "states": WIDESPREAD,
    },
    {
        "common_name": "Lime Butterfly",
        "scientific_name": "Papilio demoleus",
        "family": "Papilionidae",
        "genus": "Papilio",
        "description": (
            "A fast-flying, lemon-yellow and black swallowtail commonly seen in gardens. "
            "Lacks the tail typical of many swallowtails. "
            "A notorious pest of citrus orchards but a beautiful garden visitor."
        ),
        "habitat": "Gardens, orchards, forest clearings, urban parks",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 80,
        "wing_span_max_mm": 100,
        "is_migratory": False,
        "color_tags": ["yellow", "black"],
        "host_plants": [
            {"plant_name": "Citrus", "plant_scientific_name": "Citrus spp."},
            {"plant_name": "Lemon", "plant_scientific_name": "Citrus limon"},
            {"plant_name": "Curry Leaf", "plant_scientific_name": "Murraya koenigii"},
        ],
        "states": WIDESPREAD,
    },
    {
        "common_name": "Common Rose",
        "scientific_name": "Pachliopta aristolochiae",
        "family": "Papilionidae",
        "genus": "Pachliopta",
        "description": (
            "A slow-flying swallowtail with distinctive crimson patches on the hindwing. "
            "Toxic and avoided by predators; widely mimicked by females of the Common Mormon. "
            "Often seen nectaring at flowers in forest areas."
        ),
        "habitat": "Forests, forest edges, gardens, scrubland",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 90,
        "wing_span_max_mm": 110,
        "is_migratory": False,
        "color_tags": ["black", "red", "white"],
        "host_plants": [
            {"plant_name": "Birthwort", "plant_scientific_name": "Aristolochia indica"},
            {"plant_name": "Aristolochia", "plant_scientific_name": "Aristolochia spp."},
        ],
        "states": WIDESPREAD,
    },
    {
        "common_name": "Blue Mormon",
        "scientific_name": "Papilio polymnestor",
        "family": "Papilionidae",
        "genus": "Papilio",
        "description": (
            "The largest butterfly in India and Sri Lanka, with striking iridescent blue patches "
            "on its black wings. Found mainly in South India's forests and gardens. "
            "Males and females are similar but females are slightly paler."
        ),
        "habitat": "Moist deciduous forests, gardens near forests, riverine vegetation",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 120,
        "wing_span_max_mm": 150,
        "is_migratory": False,
        "color_tags": ["black", "blue"],
        "host_plants": [
            {"plant_name": "Citrus", "plant_scientific_name": "Citrus spp."},
            {"plant_name": "Satinwood", "plant_scientific_name": "Chloroxylon swietenia"},
        ],
        "states": ["AP", "KA", "KL", "TN", "TS", "MH", "GA", "PY", "AN"],
    },
    {
        "common_name": "Tailed Jay",
        "scientific_name": "Graphium agamemnon",
        "family": "Papilionidae",
        "genus": "Graphium",
        "description": (
            "A fast-flying, bright green-spotted black butterfly with a characteristic "
            "short tail on the hindwing. Almost always seen in motion, rarely stopping. "
            "Common in forested areas and gardens with host trees nearby."
        ),
        "habitat": "Forest edges, gardens, scrubland, secondary forests",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 80,
        "wing_span_max_mm": 100,
        "is_migratory": False,
        "color_tags": ["black", "green"],
        "host_plants": [
            {"plant_name": "Soursop", "plant_scientific_name": "Annona muricata"},
            {"plant_name": "Custard Apple", "plant_scientific_name": "Annona squamosa"},
            {"plant_name": "Champak", "plant_scientific_name": "Magnolia champaca"},
        ],
        "states": WIDESPREAD,
    },
    {
        "common_name": "Common Jay",
        "scientific_name": "Graphium doson",
        "family": "Papilionidae",
        "genus": "Graphium",
        "description": (
            "Similar to the Tailed Jay but with more extensive pale blue-green spots on both wings. "
            "A lively forest butterfly often seen gliding along forest paths. "
            "Occasionally forms mud-puddle aggregations with other species."
        ),
        "habitat": "Evergreen and semi-evergreen forests, forest clearings",
        "seasonal_appearance": [2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
        "conservation_status": "LC",
        "wing_span_min_mm": 75,
        "wing_span_max_mm": 95,
        "is_migratory": False,
        "color_tags": ["black", "blue", "white"],
        "host_plants": [
            {"plant_name": "Devil Tree", "plant_scientific_name": "Alstonia scholaris"},
            {"plant_name": "Milkwood", "plant_scientific_name": "Alstonia macrophylla"},
        ],
        "states": ["AR", "AS", "KA", "KL", "MH", "MN", "ML", "MZ", "NL", "OD", "TN", "TR", "WB", "GA", "AN"],
    },
    {
        "common_name": "Crimson Rose",
        "scientific_name": "Pachliopta hector",
        "family": "Papilionidae",
        "genus": "Pachliopta",
        "description": (
            "A strikingly beautiful swallowtail endemic to peninsular India and Sri Lanka. "
            "Deep crimson hindwing patches and white forewing spots on a velvet-black body. "
            "A model species mimicked by female Common Mormons. Typically a slow, deliberate flier."
        ),
        "habitat": "Forests, garden hedges with Aristolochia, coastal scrub",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "NT",
        "wing_span_min_mm": 90,
        "wing_span_max_mm": 115,
        "is_migratory": False,
        "color_tags": ["black", "red", "white"],
        "host_plants": [
            {"plant_name": "Birthwort", "plant_scientific_name": "Aristolochia indica"},
        ],
        "states": ["AP", "KA", "KL", "TN", "TS", "PY"],
    },
    {
        "common_name": "Southern Birdwing",
        "scientific_name": "Troides minos",
        "family": "Papilionidae",
        "genus": "Troides",
        "description": (
            "India's largest butterfly and a protected species. Males display brilliant golden-yellow "
            "hindwings against a black body. Females are larger, brown-and-yellow, and rarely seen. "
            "Found exclusively in the Western Ghats forests."
        ),
        "habitat": "Dense tropical evergreen forests, Western Ghats hill forests",
        "seasonal_appearance": [3, 4, 5, 6, 7, 8, 9, 10, 11],
        "conservation_status": "VU",
        "wing_span_min_mm": 140,
        "wing_span_max_mm": 190,
        "is_migratory": False,
        "color_tags": ["black", "yellow", "gold"],
        "host_plants": [
            {"plant_name": "Birthwort", "plant_scientific_name": "Aristolochia indica"},
            {"plant_name": "Giant Aristolochia", "plant_scientific_name": "Aristolochia tagala"},
        ],
        "states": WESTERN_GHATS,
    },
    {
        "common_name": "Common Banded Peacock",
        "scientific_name": "Papilio crino",
        "family": "Papilionidae",
        "genus": "Papilio",
        "description": (
            "A medium-sized swallowtail with bright green iridescent scales on the forewing "
            "and a distinctive blue-green band on the hindwing. "
            "Common in the Western Ghats; also found in parts of northeast India."
        ),
        "habitat": "Moist forests, forest edges, shaded gardens",
        "seasonal_appearance": [3, 4, 5, 6, 7, 8, 9, 10],
        "conservation_status": "LC",
        "wing_span_min_mm": 85,
        "wing_span_max_mm": 100,
        "is_migratory": False,
        "color_tags": ["black", "green", "blue"],
        "host_plants": [
            {"plant_name": "Cinnamon", "plant_scientific_name": "Cinnamomum verum"},
            {"plant_name": "Camphor", "plant_scientific_name": "Cinnamomum camphora"},
        ],
        "states": ["KA", "KL", "TN", "MH", "GA", "AS", "MN", "ML"],
    },
    {
        "common_name": "Five Bar Swordtail",
        "scientific_name": "Graphium antiphates",
        "family": "Papilionidae",
        "genus": "Graphium",
        "description": (
            "Easily identified by five dark bars across white wings and a long, elegant tail. "
            "A fast flier that frequently visits mud puddles and wet soil to drink minerals. "
            "Found across India wherever its host plants grow."
        ),
        "habitat": "Forests, forest margins, river banks, wet areas",
        "seasonal_appearance": [2, 3, 4, 5, 6, 7, 8, 9, 10],
        "conservation_status": "LC",
        "wing_span_min_mm": 80,
        "wing_span_max_mm": 100,
        "is_migratory": False,
        "color_tags": ["white", "black", "green"],
        "host_plants": [
            {"plant_name": "Soursop", "plant_scientific_name": "Annona muricata"},
            {"plant_name": "Polyalthia", "plant_scientific_name": "Polyalthia longifolia"},
        ],
        "states": ["AP", "AS", "KA", "KL", "MH", "MN", "ML", "OD", "TN", "TS", "WB", "GA", "AN"],
    },

    # ══════════════════════════════════════════════════════════════════
    # FAMILY: Pieridae (Whites and Yellows)
    # ══════════════════════════════════════════════════════════════════
    {
        "common_name": "Common Jezebel",
        "scientific_name": "Delias eucharis",
        "family": "Pieridae",
        "genus": "Delias",
        "description": (
            "One of India's most beautiful common butterflies. The upperside is white, "
            "but the underside is vividly patterned in yellow, red, and black. "
            "Often seen flying high in the canopy but descends to flowers in forest clearings."
        ),
        "habitat": "Forests, wooded hillsides, gardens near forests",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 65,
        "wing_span_max_mm": 80,
        "is_migratory": False,
        "color_tags": ["white", "yellow", "red", "black"],
        "host_plants": [
            {"plant_name": "Mistletoe", "plant_scientific_name": "Loranthus spp."},
            {"plant_name": "Dendrophthoe", "plant_scientific_name": "Dendrophthoe falcata"},
        ],
        "states": WIDESPREAD,
    },
    {
        "common_name": "Common Emigrant",
        "scientific_name": "Catopsilia pomona",
        "family": "Pieridae",
        "genus": "Catopsilia",
        "description": (
            "A migratory butterfly that forms massive aggregations during migration, "
            "sometimes numbering in thousands. Males are pale lemon-yellow; "
            "females range from white to yellow with variable dark spotting."
        ),
        "habitat": "Open areas, scrubland, gardens, forest edges, river banks",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 58,
        "wing_span_max_mm": 72,
        "is_migratory": True,
        "color_tags": ["yellow", "white"],
        "host_plants": [
            {"plant_name": "Cassia", "plant_scientific_name": "Cassia fistula"},
            {"plant_name": "Senna", "plant_scientific_name": "Senna spp."},
        ],
        "states": WIDESPREAD,
    },
    {
        "common_name": "Mottled Emigrant",
        "scientific_name": "Catopsilia pyranthe",
        "family": "Pieridae",
        "genus": "Catopsilia",
        "description": (
            "Similar to the Common Emigrant but with distinctive mottled markings on the underside. "
            "Also a migratory species that moves in large numbers seasonally. "
            "Commonly seen at wet soil and mud puddles for mineral intake."
        ),
        "habitat": "Open scrub, gardens, roadsides, agricultural land, forest edges",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 55,
        "wing_span_max_mm": 70,
        "is_migratory": True,
        "color_tags": ["white", "yellow", "green"],
        "host_plants": [
            {"plant_name": "Senna", "plant_scientific_name": "Senna spp."},
            {"plant_name": "Cassia", "plant_scientific_name": "Cassia spp."},
        ],
        "states": WIDESPREAD,
    },
    {
        "common_name": "Common Grass Yellow",
        "scientific_name": "Eurema hecabe",
        "family": "Pieridae",
        "genus": "Eurema",
        "description": (
            "The most common small yellow butterfly across India. Bright yellow with black borders, "
            "often seen in fluttering groups at flower patches. "
            "Highly variable with seasonal forms showing different wing patterns."
        ),
        "habitat": "Grasslands, gardens, open forest, roadsides, scrubland",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 35,
        "wing_span_max_mm": 45,
        "is_migratory": False,
        "color_tags": ["yellow", "black"],
        "host_plants": [
            {"plant_name": "Cassia", "plant_scientific_name": "Cassia spp."},
            {"plant_name": "Mimosa", "plant_scientific_name": "Mimosa pudica"},
            {"plant_name": "Indian Laburnum", "plant_scientific_name": "Cassia fistula"},
        ],
        "states": WIDESPREAD,
    },
    {
        "common_name": "Psyche",
        "scientific_name": "Leptosia nina",
        "family": "Pieridae",
        "genus": "Leptosia",
        "description": (
            "A tiny, fragile-looking white butterfly with a single black dot on the forewing tip. "
            "Flies in a weak, fluttering manner close to the ground in shaded areas. "
            "Easily identified by its small size and bobbing flight pattern."
        ),
        "habitat": "Shaded forest floors, humid gardens, forest understorey",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 32,
        "wing_span_max_mm": 42,
        "is_migratory": False,
        "color_tags": ["white", "black"],
        "host_plants": [
            {"plant_name": "Cleome", "plant_scientific_name": "Cleome viscosa"},
            {"plant_name": "Crataeva", "plant_scientific_name": "Crataeva spp."},
        ],
        "states": WIDESPREAD,
    },
    {
        "common_name": "Indian Cabbage White",
        "scientific_name": "Pieris brassicae",
        "family": "Pieridae",
        "genus": "Pieris",
        "description": (
            "A classic white butterfly with black wing tips, very common in agricultural areas "
            "and Himalayan hills. A pest of cruciferous crops. The larva is the famous green cabbage worm. "
            "Most abundant in cooler months in northern India."
        ),
        "habitat": "Agricultural fields, hill gardens, mountain meadows, vegetable patches",
        "seasonal_appearance": [1, 2, 3, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 55,
        "wing_span_max_mm": 65,
        "is_migratory": False,
        "color_tags": ["white", "black"],
        "host_plants": [
            {"plant_name": "Cabbage", "plant_scientific_name": "Brassica oleracea"},
            {"plant_name": "Mustard", "plant_scientific_name": "Brassica juncea"},
            {"plant_name": "Nasturtium", "plant_scientific_name": "Tropaeolum majus"},
        ],
        "states": NORTH_INDIA + ["HP", "UK", "JK"],
    },
    {
        "common_name": "Striped Albatross",
        "scientific_name": "Appias libythea",
        "family": "Pieridae",
        "genus": "Appias",
        "description": (
            "A robust white butterfly with neat black striping. Males are brilliant white "
            "with fine black markings; females have more extensive dark areas. "
            "Often congregates at riverside sandbars for puddling."
        ),
        "habitat": "Forest clearings, river margins, gardens, secondary forests",
        "seasonal_appearance": [2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
        "conservation_status": "LC",
        "wing_span_min_mm": 55,
        "wing_span_max_mm": 70,
        "is_migratory": False,
        "color_tags": ["white", "black"],
        "host_plants": [
            {"plant_name": "Capparis", "plant_scientific_name": "Capparis spp."},
            {"plant_name": "Crataeva", "plant_scientific_name": "Crataeva religiosa"},
        ],
        "states": WIDESPREAD,
    },

    # ══════════════════════════════════════════════════════════════════
    # FAMILY: Nymphalidae (Brushfoots)
    # ══════════════════════════════════════════════════════════════════
    {
        "common_name": "Plain Tiger",
        "scientific_name": "Danaus chrysippus",
        "family": "Nymphalidae",
        "genus": "Danaus",
        "description": (
            "One of India's most recognizable butterflies — orange wings with broad black borders "
            "and white spots. Toxic and avoided by predators. Migratory and widespread across India. "
            "The caterpillar sequesters toxins from its milkweed host plants."
        ),
        "habitat": "Open areas, gardens, scrubland, grasslands, coastal areas",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 65,
        "wing_span_max_mm": 80,
        "is_migratory": True,
        "color_tags": ["orange", "black", "white"],
        "host_plants": [
            {"plant_name": "Crown Flower", "plant_scientific_name": "Calotropis gigantea"},
            {"plant_name": "Swallow-wort", "plant_scientific_name": "Calotropis procera"},
        ],
        "states": WIDESPREAD,
    },
    {
        "common_name": "Common Tiger",
        "scientific_name": "Danaus genutia",
        "family": "Nymphalidae",
        "genus": "Danaus",
        "description": (
            "Similar to the Plain Tiger but with striped orange-and-black forewings resembling a tiger. "
            "Distasteful to birds and often found in large aggregations at roost sites. "
            "Participates in spectacular mass migrations across peninsular India."
        ),
        "habitat": "Open forests, gardens, scrubland, grasslands",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 70,
        "wing_span_max_mm": 85,
        "is_migratory": True,
        "color_tags": ["orange", "black", "white"],
        "host_plants": [
            {"plant_name": "Twiners", "plant_scientific_name": "Cynanchum spp."},
            {"plant_name": "Tylophora", "plant_scientific_name": "Tylophora spp."},
        ],
        "states": WIDESPREAD,
    },
    {
        "common_name": "Blue Tiger",
        "scientific_name": "Tirumala limniace",
        "family": "Nymphalidae",
        "genus": "Tirumala",
        "description": (
            "A striking butterfly with blue-streaked black wings dotted with white spots. "
            "Toxic and mimicked by non-toxic species. Forms large migratory aggregations "
            "especially along the Western Ghats in October and November."
        ),
        "habitat": "Forests, forest edges, gardens, scrubland",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 75,
        "wing_span_max_mm": 95,
        "is_migratory": True,
        "color_tags": ["blue", "black", "white"],
        "host_plants": [
            {"plant_name": "Cressa", "plant_scientific_name": "Cressa cretica"},
            {"plant_name": "Cynanchum", "plant_scientific_name": "Cynanchum spp."},
        ],
        "states": WIDESPREAD,
    },
    {
        "common_name": "Glassy Tiger",
        "scientific_name": "Parantica aglea",
        "family": "Nymphalidae",
        "genus": "Parantica",
        "description": (
            "Semi-transparent bluish-grey wings with black borders and white spots give this "
            "butterfly its 'glassy' appearance. Slow-flying and toxic. "
            "Found in forests at higher elevations and is part of the tiger migratory complex."
        ),
        "habitat": "Moist forests, hill forests, forest clearings",
        "seasonal_appearance": [3, 4, 5, 6, 7, 8, 9, 10, 11],
        "conservation_status": "LC",
        "wing_span_min_mm": 80,
        "wing_span_max_mm": 100,
        "is_migratory": True,
        "color_tags": ["grey", "black", "white", "blue"],
        "host_plants": [
            {"plant_name": "Tylophora", "plant_scientific_name": "Tylophora spp."},
            {"plant_name": "Marsdenia", "plant_scientific_name": "Marsdenia spp."},
        ],
        "states": ["AP", "AS", "KA", "KL", "MH", "MN", "ML", "NL", "TN", "TS", "WB", "GA", "SK"],
    },
    {
        "common_name": "Common Indian Crow",
        "scientific_name": "Euploea core",
        "family": "Nymphalidae",
        "genus": "Euploea",
        "description": (
            "Deep glossy blue-black wings with small white dots along the margins. "
            "One of India's most common forest butterflies. Toxic and warningly coloured. "
            "Males have a small hair-pencil organ for dispersing pheromones during courtship."
        ),
        "habitat": "Forests, forest edges, gardens, mangroves",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 75,
        "wing_span_max_mm": 95,
        "is_migratory": False,
        "color_tags": ["black", "blue", "white"],
        "host_plants": [
            {"plant_name": "Oleander", "plant_scientific_name": "Nerium oleander"},
            {"plant_name": "Crown Flower", "plant_scientific_name": "Calotropis gigantea"},
            {"plant_name": "Fig", "plant_scientific_name": "Ficus spp."},
        ],
        "states": WIDESPREAD,
    },
    {
        "common_name": "Tawny Coster",
        "scientific_name": "Acraea terpsicore",
        "family": "Nymphalidae",
        "genus": "Acraea",
        "description": (
            "A small, slow-flying orange butterfly with distinctive black spots and wing borders. "
            "Toxic and a member of the mimicry complex. Commonly found in large groups "
            "in open grasslands and pastures. Has become increasingly common in urban areas."
        ),
        "habitat": "Grasslands, scrubland, open areas, urban parks, roadsides",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 45,
        "wing_span_max_mm": 60,
        "is_migratory": False,
        "color_tags": ["orange", "black"],
        "host_plants": [
            {"plant_name": "Passion Flower", "plant_scientific_name": "Passiflora foetida"},
            {"plant_name": "Wild Passion Fruit", "plant_scientific_name": "Passiflora spp."},
        ],
        "states": WIDESPREAD,
    },
    {
        "common_name": "Lemon Pansy",
        "scientific_name": "Junonia lemonias",
        "family": "Nymphalidae",
        "genus": "Junonia",
        "description": (
            "An attractive butterfly with a row of eyespots along both wing surfaces. "
            "Brown with cream-coloured patches and two prominent orange-ringed eyespots on each wing. "
            "A common garden and open-area butterfly found across the country."
        ),
        "habitat": "Gardens, open areas, grasslands, scrubland, roadsides",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 45,
        "wing_span_max_mm": 60,
        "is_migratory": False,
        "color_tags": ["brown", "orange", "cream"],
        "host_plants": [
            {"plant_name": "Hygrophila", "plant_scientific_name": "Hygrophila spp."},
            {"plant_name": "Barleria", "plant_scientific_name": "Barleria spp."},
        ],
        "states": WIDESPREAD,
    },
    {
        "common_name": "Peacock Pansy",
        "scientific_name": "Junonia almana",
        "family": "Nymphalidae",
        "genus": "Junonia",
        "description": (
            "Named for its peacock-like eyespots — large concentric circles of blue, orange, "
            "and black on tawny-orange wings. The wet-season form has prominent eyespots; "
            "the dry-season form is leaf-like with reduced spots. Very common in open areas."
        ),
        "habitat": "Open grasslands, gardens, paddy fields, scrubland, coastal areas",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 55,
        "wing_span_max_mm": 68,
        "is_migratory": False,
        "color_tags": ["orange", "yellow", "brown", "blue"],
        "host_plants": [
            {"plant_name": "Balsam", "plant_scientific_name": "Impatiens spp."},
            {"plant_name": "Nelsonia", "plant_scientific_name": "Nelsonia canescens"},
        ],
        "states": WIDESPREAD,
    },
    {
        "common_name": "Blue Pansy",
        "scientific_name": "Junonia orithya",
        "family": "Nymphalidae",
        "genus": "Junonia",
        "description": (
            "Males are unmistakable with their vivid blue hind wings and orange forewing base. "
            "Females are browner with less intense blue. A fast, skittish butterfly that "
            "sunbathes on bare ground with wings spread. Highly territorial."
        ),
        "habitat": "Open dry areas, sand dunes, dry grasslands, scrubland",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 45,
        "wing_span_max_mm": 60,
        "is_migratory": False,
        "color_tags": ["blue", "orange", "black"],
        "host_plants": [
            {"plant_name": "Plantain", "plant_scientific_name": "Plantago spp."},
            {"plant_name": "Acanthus", "plant_scientific_name": "Acanthus spp."},
        ],
        "states": WIDESPREAD,
    },
    {
        "common_name": "Common Castor",
        "scientific_name": "Ariadne merione",
        "family": "Nymphalidae",
        "genus": "Ariadne",
        "description": (
            "A small, fast-flying brown butterfly patterned with intricate wavy lines. "
            "Easily overlooked on bark or leaf litter due to cryptic colouring. "
            "Almost always found near castor plants, which are its sole larval host."
        ),
        "habitat": "Open scrub, agricultural land near castor, roadsides, dry forests",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 40,
        "wing_span_max_mm": 52,
        "is_migratory": False,
        "color_tags": ["brown", "orange"],
        "host_plants": [
            {"plant_name": "Castor", "plant_scientific_name": "Ricinus communis"},
        ],
        "states": WIDESPREAD,
    },
    {
        "common_name": "Common Baron",
        "scientific_name": "Euthalia aconthea",
        "family": "Nymphalidae",
        "genus": "Euthalia",
        "description": (
            "Males are metallic olive-green; females are larger and more brownish. "
            "A strong flier often seen perching high on mango leaves with wings spread. "
            "Caterpillars are cryptically coloured green to match mango leaves perfectly."
        ),
        "habitat": "Mango orchards, forests with Mangifera, gardens",
        "seasonal_appearance": [3, 4, 5, 6, 7, 8, 9, 10],
        "conservation_status": "LC",
        "wing_span_min_mm": 65,
        "wing_span_max_mm": 85,
        "is_migratory": False,
        "color_tags": ["green", "brown", "olive"],
        "host_plants": [
            {"plant_name": "Mango", "plant_scientific_name": "Mangifera indica"},
        ],
        "states": WIDESPREAD,
    },
    {
        "common_name": "Commander",
        "scientific_name": "Moduza procris",
        "family": "Nymphalidae",
        "genus": "Moduza",
        "description": (
            "A striking butterfly with chocolate-brown wings crossed by a broad cream-white band. "
            "A strong, high-flying species often seen gliding in forest clearings. "
            "Rests with wings outspread on leaves or tree trunks."
        ),
        "habitat": "Forest edges, secondary forests, wooded areas, gardens",
        "seasonal_appearance": [3, 4, 5, 6, 7, 8, 9, 10, 11],
        "conservation_status": "LC",
        "wing_span_min_mm": 65,
        "wing_span_max_mm": 80,
        "is_migratory": False,
        "color_tags": ["brown", "white"],
        "host_plants": [
            {"plant_name": "Wendlandia", "plant_scientific_name": "Wendlandia spp."},
            {"plant_name": "Pavetta", "plant_scientific_name": "Pavetta spp."},
        ],
        "states": ["AP", "AS", "KA", "KL", "MH", "MN", "ML", "OD", "TN", "TS", "WB", "GA", "AN"],
    },
    {
        "common_name": "Common Sailer",
        "scientific_name": "Neptis hylas",
        "family": "Nymphalidae",
        "genus": "Neptis",
        "description": (
            "Black wings with a bold white band pattern, flying with distinctive 'sailing' glides. "
            "One of the most common and easily identified forest butterflies in India. "
            "Often seen gliding low along paths and forest edges."
        ),
        "habitat": "Forests, forest edges, gardens, secondary growth",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 50,
        "wing_span_max_mm": 65,
        "is_migratory": False,
        "color_tags": ["black", "white"],
        "host_plants": [
            {"plant_name": "Derris", "plant_scientific_name": "Derris spp."},
            {"plant_name": "Millettia", "plant_scientific_name": "Millettia spp."},
        ],
        "states": WIDESPREAD,
    },
    {
        "common_name": "Common Leopard",
        "scientific_name": "Phalanta phalantha",
        "family": "Nymphalidae",
        "genus": "Phalanta",
        "description": (
            "Tawny-orange wings densely spotted with black dots, resembling a leopard's coat. "
            "A fast, restless flier often seen at flowers. Particularly attracted to damp patches. "
            "Common in gardens with Salicaceae host plants."
        ),
        "habitat": "Gardens, forest edges, river margins, scrubland",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 48,
        "wing_span_max_mm": 58,
        "is_migratory": False,
        "color_tags": ["orange", "black"],
        "host_plants": [
            {"plant_name": "Flacourtia", "plant_scientific_name": "Flacourtia indica"},
            {"plant_name": "Poplar", "plant_scientific_name": "Populus spp."},
            {"plant_name": "Wild Date", "plant_scientific_name": "Xylosma longifolia"},
        ],
        "states": WIDESPREAD,
    },
    {
        "common_name": "Common Evening Brown",
        "scientific_name": "Melanitis leda",
        "family": "Nymphalidae",
        "genus": "Melanitis",
        "description": (
            "A large, cryptically coloured brown butterfly with leaf-like markings. "
            "Active mainly at dusk and dawn; rests in leaf litter during the day. "
            "Has a striking wet-season form with prominent eyespots and a leaf-like dry-season form."
        ),
        "habitat": "Forest edges, gardens, grasslands, paddy fields, wooded areas",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 65,
        "wing_span_max_mm": 80,
        "is_migratory": False,
        "color_tags": ["brown", "orange"],
        "host_plants": [
            {"plant_name": "Rice", "plant_scientific_name": "Oryza sativa"},
            {"plant_name": "Bamboo", "plant_scientific_name": "Bambusa spp."},
            {"plant_name": "Sugar Cane", "plant_scientific_name": "Saccharum officinarum"},
        ],
        "states": WIDESPREAD,
    },
    {
        "common_name": "Common Three Ring",
        "scientific_name": "Ypthima asterope",
        "family": "Nymphalidae",
        "genus": "Ypthima",
        "description": (
            "A small brown butterfly with three prominent eyespots on the hindwing underside. "
            "Flutters weakly close to the ground in grassy areas. "
            "One of several similar Ypthima species in India, distinguished by its three-ringed pattern."
        ),
        "habitat": "Grasslands, scrubland, forest margins, roadsides",
        "seasonal_appearance": [2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
        "conservation_status": "LC",
        "wing_span_min_mm": 32,
        "wing_span_max_mm": 42,
        "is_migratory": False,
        "color_tags": ["brown"],
        "host_plants": [
            {"plant_name": "Grasses", "plant_scientific_name": "Poaceae spp."},
            {"plant_name": "Cynodon", "plant_scientific_name": "Cynodon dactylon"},
        ],
        "states": WIDESPREAD,
    },
    {
        "common_name": "Common Bushbrown",
        "scientific_name": "Mycalesis perseus",
        "family": "Nymphalidae",
        "genus": "Mycalesis",
        "description": (
            "A common woodland brown butterfly with a row of eyespots on the hindwing underside. "
            "Flies close to the ground and settles on low vegetation. "
            "Often mistaken for dead leaves when resting with wings folded."
        ),
        "habitat": "Forest floors, shaded gardens, bamboo groves, moist woodland",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 40,
        "wing_span_max_mm": 55,
        "is_migratory": False,
        "color_tags": ["brown"],
        "host_plants": [
            {"plant_name": "Grasses", "plant_scientific_name": "Poaceae spp."},
            {"plant_name": "Bamboo", "plant_scientific_name": "Bambusa spp."},
        ],
        "states": WIDESPREAD,
    },
    {
        "common_name": "Autumn Leaf",
        "scientific_name": "Doleschallia bisaltide",
        "family": "Nymphalidae",
        "genus": "Doleschallia",
        "description": (
            "One of nature's finest camouflage artists. When wings are folded, it looks precisely "
            "like a dry, dead leaf complete with a leaf stalk, midrib, and brown blotches. "
            "The upperside is bright orange with a dark border — a completely different appearance."
        ),
        "habitat": "Forests, forest edges, wooded gardens",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 65,
        "wing_span_max_mm": 85,
        "is_migratory": False,
        "color_tags": ["orange", "brown", "black"],
        "host_plants": [
            {"plant_name": "Pseuderanthemum", "plant_scientific_name": "Pseuderanthemum spp."},
            {"plant_name": "Asystasia", "plant_scientific_name": "Asystasia gangetica"},
        ],
        "states": ["AP", "AS", "KA", "KL", "MH", "MN", "ML", "TN", "TS", "WB", "GA", "AN", "PY"],
    },
    {
        "common_name": "Indian Fritillary",
        "scientific_name": "Argynnis hyperbius",
        "family": "Nymphalidae",
        "genus": "Argynnis",
        "description": (
            "Males are bright orange with black spots; females have a distinctive iridescent purple "
            "patch on the forewing tip. A fast-flying butterfly of open, grassy hillsides. "
            "The underside has beautiful silvery spots on the hindwing."
        ),
        "habitat": "Open grasslands, hill meadows, forest clearings, scrubland at higher elevation",
        "seasonal_appearance": [3, 4, 5, 6, 7, 8, 9, 10],
        "conservation_status": "LC",
        "wing_span_min_mm": 60,
        "wing_span_max_mm": 75,
        "is_migratory": False,
        "color_tags": ["orange", "black", "purple"],
        "host_plants": [
            {"plant_name": "Violet", "plant_scientific_name": "Viola spp."},
        ],
        "states": ["AR", "AS", "HP", "JK", "KA", "MN", "ML", "NL", "SK", "UK", "WB"],
    },

    # ══════════════════════════════════════════════════════════════════
    # FAMILY: Lycaenidae (Blues, Coppers, Hairstreaks)
    # ══════════════════════════════════════════════════════════════════
    {
        "common_name": "Common Cerulean",
        "scientific_name": "Jamides celeno",
        "family": "Lycaenidae",
        "genus": "Jamides",
        "description": (
            "Males have sky-blue upperside; females are browner. The underside is a pale, "
            "iridescent blue-grey with fine white streaks. A fast, skittish small butterfly "
            "common in secondary growth and forest edges."
        ),
        "habitat": "Secondary forests, forest edges, gardens, scrubland",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 28,
        "wing_span_max_mm": 38,
        "is_migratory": False,
        "color_tags": ["blue", "white"],
        "host_plants": [
            {"plant_name": "Indian Coral Tree", "plant_scientific_name": "Erythrina spp."},
            {"plant_name": "Derris", "plant_scientific_name": "Derris spp."},
        ],
        "states": WIDESPREAD,
    },
    {
        "common_name": "Gram Blue",
        "scientific_name": "Euchrysops cnejus",
        "family": "Lycaenidae",
        "genus": "Euchrysops",
        "description": (
            "A tiny blue butterfly extremely common in agricultural areas. Males are bright blue; "
            "females have blue restricted to the wing base. Larvae feed on leguminous crops "
            "including gram, making it a familiar sight in farmland."
        ),
        "habitat": "Agricultural land, gardens, open scrub, roadsides",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 22,
        "wing_span_max_mm": 30,
        "is_migratory": False,
        "color_tags": ["blue", "white"],
        "host_plants": [
            {"plant_name": "Chickpea", "plant_scientific_name": "Cicer arietinum"},
            {"plant_name": "Cowpea", "plant_scientific_name": "Vigna unguiculata"},
            {"plant_name": "Pigeon Pea", "plant_scientific_name": "Cajanus cajan"},
        ],
        "states": WIDESPREAD,
    },
    {
        "common_name": "Common Pierrot",
        "scientific_name": "Castalius rosimon",
        "family": "Lycaenidae",
        "genus": "Castalius",
        "description": (
            "White wings with distinctive black spots on both surfaces. "
            "One of the more easily identified small blues. Flies with a quick, "
            "bobbing flight near its jujube host plants. Often seen in dry scrub areas."
        ),
        "habitat": "Dry scrub, gardens, thorny forest, agricultural edges",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 25,
        "wing_span_max_mm": 35,
        "is_migratory": False,
        "color_tags": ["white", "black"],
        "host_plants": [
            {"plant_name": "Jujube", "plant_scientific_name": "Ziziphus jujuba"},
            {"plant_name": "Ber", "plant_scientific_name": "Ziziphus mauritiana"},
        ],
        "states": WIDESPREAD,
    },
    {
        "common_name": "Common Hedge Blue",
        "scientific_name": "Acytolepis puspa",
        "family": "Lycaenidae",
        "genus": "Acytolepis",
        "description": (
            "Males are bright sky-blue; females are brown with a blue basal wash. "
            "Extremely common in suburban and garden habitats. "
            "Often seen resting on hedges and low bushes in the early morning sun."
        ),
        "habitat": "Gardens, hedgerows, urban parks, forest edges, scrubland",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 25,
        "wing_span_max_mm": 35,
        "is_migratory": False,
        "color_tags": ["blue", "brown"],
        "host_plants": [
            {"plant_name": "Grewia", "plant_scientific_name": "Grewia spp."},
            {"plant_name": "Ehretia", "plant_scientific_name": "Ehretia acuminata"},
        ],
        "states": WIDESPREAD,
    },
    {
        "common_name": "Zebra Blue",
        "scientific_name": "Leptotes plinius",
        "family": "Lycaenidae",
        "genus": "Leptotes",
        "description": (
            "Named for the zebra-like pattern of fine brown and white stripes on the underside. "
            "The upperside is purple-blue in males, brown in females. "
            "Very common in gardens with plumbago plants."
        ),
        "habitat": "Gardens, scrubland, coastal areas, urban parks",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 22,
        "wing_span_max_mm": 30,
        "is_migratory": False,
        "color_tags": ["blue", "purple", "white"],
        "host_plants": [
            {"plant_name": "Plumbago", "plant_scientific_name": "Plumbago spp."},
            {"plant_name": "Bean", "plant_scientific_name": "Phaseolus spp."},
        ],
        "states": WIDESPREAD,
    },
    {
        "common_name": "Tailed Pea Blue",
        "scientific_name": "Lampides boeticus",
        "family": "Lycaenidae",
        "genus": "Lampides",
        "description": (
            "A tiny bright blue butterfly with a short hindwing tail and small orange-ringed "
            "eyespots near the tail. One of the world's most widespread butterfly species. "
            "Males have dazzling iridescent blue uppersides; females are brownish."
        ),
        "habitat": "Open areas, gardens, scrubland, agricultural fields",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 25,
        "wing_span_max_mm": 35,
        "is_migratory": True,
        "color_tags": ["blue", "purple", "white"],
        "host_plants": [
            {"plant_name": "Pea", "plant_scientific_name": "Pisum sativum"},
            {"plant_name": "Bladder Senna", "plant_scientific_name": "Colutea arborescens"},
            {"plant_name": "Crotalaria", "plant_scientific_name": "Crotalaria spp."},
        ],
        "states": WIDESPREAD,
    },
    {
        "common_name": "Common Lineblue",
        "scientific_name": "Prosotas nora",
        "family": "Lycaenidae",
        "genus": "Prosotas",
        "description": (
            "A very small, delicate blue butterfly with fine line-markings on the underside. "
            "Found wherever its host Loranthus grows. Flies weakly near parasitic plants "
            "on tree canopies and is often seen at ant-attended plant growths."
        ),
        "habitat": "Forests, forest edges, gardens with parasitic plants",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 18,
        "wing_span_max_mm": 26,
        "is_migratory": False,
        "color_tags": ["blue", "grey"],
        "host_plants": [
            {"plant_name": "Mistletoe", "plant_scientific_name": "Loranthus spp."},
            {"plant_name": "Dendrophthoe", "plant_scientific_name": "Dendrophthoe falcata"},
        ],
        "states": WIDESPREAD,
    },
    {
        "common_name": "Common Quaker",
        "scientific_name": "Neopithecops zalmora",
        "family": "Lycaenidae",
        "genus": "Neopithecops",
        "description": (
            "One of the smallest butterflies in India, dull brown above and white below "
            "with fine brown spots. Flies very close to the ground in dense shade. "
            "Despite its plain appearance, very widespread and common."
        ),
        "habitat": "Shaded forest floor, forest understorey, damp woodland",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 18,
        "wing_span_max_mm": 26,
        "is_migratory": False,
        "color_tags": ["brown", "white"],
        "host_plants": [
            {"plant_name": "Glycosmis", "plant_scientific_name": "Glycosmis pentaphylla"},
        ],
        "states": ["AP", "AS", "KA", "KL", "MH", "MN", "ML", "OD", "TN", "TS", "WB", "GA", "AN", "PY"],
    },
    {
        "common_name": "Bright Babul Blue",
        "scientific_name": "Azanus jesous",
        "family": "Lycaenidae",
        "genus": "Azanus",
        "description": (
            "Brilliant iridescent blue wings in males, brown in females. Very small but vivid. "
            "Common in dry scrub and thorn forest wherever acacia trees grow. "
            "Often seen nectaring at tiny flowers with a rapid darting flight."
        ),
        "habitat": "Dry scrub, thorn forest, semi-arid areas, roadsides",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 20,
        "wing_span_max_mm": 28,
        "is_migratory": False,
        "color_tags": ["blue", "brown"],
        "host_plants": [
            {"plant_name": "Acacia", "plant_scientific_name": "Acacia spp."},
            {"plant_name": "Babul", "plant_scientific_name": "Vachellia nilotica"},
        ],
        "states": ["AP", "GJ", "HR", "KA", "MP", "MH", "RJ", "TN", "TS", "UP", "DL"],
    },

    # ══════════════════════════════════════════════════════════════════
    # FAMILY: Hesperiidae (Skippers)
    # ══════════════════════════════════════════════════════════════════
    {
        "common_name": "Common Banded Awl",
        "scientific_name": "Hasora chromus",
        "family": "Hesperiidae",
        "genus": "Hasora",
        "description": (
            "A fast-flying, robust dark brown skipper with a pale band on the forewing. "
            "Rests with forewing and hindwing at different angles, a characteristic skipper pose. "
            "Crepuscular — most active at dawn and dusk."
        ),
        "habitat": "Forests, forest edges, gardens",
        "seasonal_appearance": [3, 4, 5, 6, 7, 8, 9, 10],
        "conservation_status": "LC",
        "wing_span_min_mm": 45,
        "wing_span_max_mm": 58,
        "is_migratory": False,
        "color_tags": ["brown", "black", "white"],
        "host_plants": [
            {"plant_name": "Derris", "plant_scientific_name": "Derris trifoliata"},
            {"plant_name": "Millettia", "plant_scientific_name": "Millettia spp."},
        ],
        "states": WIDESPREAD,
    },
    {
        "common_name": "Rice Swift",
        "scientific_name": "Borbo cinnara",
        "family": "Hesperiidae",
        "genus": "Borbo",
        "description": (
            "A small, swift-flying brown skipper with translucent white spots on the forewing. "
            "One of the most common skippers in rice-growing areas across India. "
            "Flies with a rapid, darting motion close to the ground."
        ),
        "habitat": "Rice fields, grasslands, paddy margins, open scrub",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 28,
        "wing_span_max_mm": 36,
        "is_migratory": False,
        "color_tags": ["brown", "white"],
        "host_plants": [
            {"plant_name": "Rice", "plant_scientific_name": "Oryza sativa"},
            {"plant_name": "Grasses", "plant_scientific_name": "Poaceae spp."},
        ],
        "states": WIDESPREAD,
    },
    {
        "common_name": "Chestnut Bob",
        "scientific_name": "Iambrix salsala",
        "family": "Hesperiidae",
        "genus": "Iambrix",
        "description": (
            "A small, chestnut-brown skipper with a golden-orange sheen. "
            "The male has a dark scent brand (stigma) on the forewing. "
            "Common in forest clearings and along paths in southern India."
        ),
        "habitat": "Forest clearings, grassy paths, secondary growth",
        "seasonal_appearance": [2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
        "conservation_status": "LC",
        "wing_span_min_mm": 28,
        "wing_span_max_mm": 36,
        "is_migratory": False,
        "color_tags": ["brown", "orange"],
        "host_plants": [
            {"plant_name": "Grasses", "plant_scientific_name": "Poaceae spp."},
        ],
        "states": ["AP", "AS", "KA", "KL", "MH", "OD", "TN", "TS", "WB", "GA", "AN"],
    },
    {
        "common_name": "Indian Palm Bob",
        "scientific_name": "Suastus gremius",
        "family": "Hesperiidae",
        "genus": "Suastus",
        "description": (
            "A small, dark brown skipper strongly associated with palm trees. "
            "The caterpillar rolls palm leaves into a distinctive tubular shelter. "
            "Very common in coconut groves and palm-lined areas of coastal and peninsular India."
        ),
        "habitat": "Palm groves, coconut plantations, gardens with palms",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 26,
        "wing_span_max_mm": 34,
        "is_migratory": False,
        "color_tags": ["brown"],
        "host_plants": [
            {"plant_name": "Coconut Palm", "plant_scientific_name": "Cocos nucifera"},
            {"plant_name": "Areca Palm", "plant_scientific_name": "Areca catechu"},
            {"plant_name": "Date Palm", "plant_scientific_name": "Phoenix dactylifera"},
        ],
        "states": ["AP", "GA", "GJ", "KA", "KL", "MH", "OD", "TN", "TS", "WB", "AN", "PY"],
    },

    # ══════════════════════════════════════════════════════════════════
    # ADDITIONAL NOTABLE SPECIES
    # ══════════════════════════════════════════════════════════════════
    {
        "common_name": "Common Map",
        "scientific_name": "Cyrestis thyodamas",
        "family": "Nymphalidae",
        "genus": "Cyrestis",
        "description": (
            "White wings with intricate map-like brown lines across the entire surface. "
            "Rests with wings spread flat, often on the ground or bare rocks. "
            "The pattern is so distinctive it cannot be confused with any other Indian butterfly."
        ),
        "habitat": "Forests, streams, rocky outcrops, moist wooded areas",
        "seasonal_appearance": [3, 4, 5, 6, 7, 8, 9, 10],
        "conservation_status": "LC",
        "wing_span_min_mm": 55,
        "wing_span_max_mm": 70,
        "is_migratory": False,
        "color_tags": ["white", "brown"],
        "host_plants": [
            {"plant_name": "Fig", "plant_scientific_name": "Ficus spp."},
        ],
        "states": ["AR", "AS", "HP", "KA", "KL", "MH", "MN", "ML", "NL", "SK", "TN", "UK", "WB"],
    },
    {
        "common_name": "Painted Lady",
        "scientific_name": "Vanessa cardui",
        "family": "Nymphalidae",
        "genus": "Vanessa",
        "description": (
            "One of the world's most widespread butterflies, found on every continent except Antarctica. "
            "Orange-and-black patterned wings with white spots. A renowned long-distance migrant "
            "that travels thousands of kilometres. Occasionally common in India during migrations."
        ),
        "habitat": "Open areas, gardens, hillsides, agricultural fields",
        "seasonal_appearance": [1, 2, 3, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 55,
        "wing_span_max_mm": 70,
        "is_migratory": True,
        "color_tags": ["orange", "black", "white"],
        "host_plants": [
            {"plant_name": "Thistle", "plant_scientific_name": "Cirsium spp."},
            {"plant_name": "Burdock", "plant_scientific_name": "Arctium spp."},
            {"plant_name": "Hollyhock", "plant_scientific_name": "Alcea rosea"},
        ],
        "states": NORTH_INDIA + ["HP", "UK", "JK", "KA", "TN"],
    },
    {
        "common_name": "Indian Red Admiral",
        "scientific_name": "Vanessa indica",
        "family": "Nymphalidae",
        "genus": "Vanessa",
        "description": (
            "Closely related to the Red Admiral of Europe. Black wings with a broad red band "
            "across the forewing and white spots at the apex. Restricted mainly to Himalayan ranges "
            "and Western Ghats at higher elevations."
        ),
        "habitat": "Hill forests, mountain meadows, gardens above 1000m elevation",
        "seasonal_appearance": [3, 4, 5, 6, 7, 8, 9, 10],
        "conservation_status": "LC",
        "wing_span_min_mm": 55,
        "wing_span_max_mm": 65,
        "is_migratory": False,
        "color_tags": ["black", "red", "white"],
        "host_plants": [
            {"plant_name": "Nettle", "plant_scientific_name": "Urtica spp."},
            {"plant_name": "Girardinia", "plant_scientific_name": "Girardinia diversifolia"},
        ],
        "states": ["AR", "AS", "HP", "JK", "KA", "KL", "MN", "ML", "NL", "SK", "TN", "UK", "WB"],
    },
    {
        "common_name": "Malabar Raven",
        "scientific_name": "Papilio dravidarum",
        "family": "Papilionidae",
        "genus": "Papilio",
        "description": (
            "A large, velvety-black swallowtail endemic to the Western Ghats of India. "
            "One of the rarer swallowtails, primarily found in dense evergreen forests. "
            "Resembles the Malabar Banded Swallowtail but is entirely black with no white bands."
        ),
        "habitat": "Dense tropical evergreen forests, moist hill forests of Western Ghats",
        "seasonal_appearance": [5, 6, 7, 8, 9, 10],
        "conservation_status": "VU",
        "wing_span_min_mm": 110,
        "wing_span_max_mm": 130,
        "is_migratory": False,
        "color_tags": ["black"],
        "host_plants": [
            {"plant_name": "Toddalia", "plant_scientific_name": "Toddalia asiatica"},
            {"plant_name": "Curry Leaf", "plant_scientific_name": "Murraya koenigii"},
        ],
        "states": WESTERN_GHATS,
    },
    {
        "common_name": "Malabar Banded Peacock",
        "scientific_name": "Papilio buddha",
        "family": "Papilionidae",
        "genus": "Papilio",
        "description": (
            "A large, stunning swallowtail endemic to the Western Ghats. "
            "Brilliant metallic green forewing band on a black body, listed in CITES Appendix II. "
            "Flies high in the forest canopy; occasionally descends to riverbanks."
        ),
        "habitat": "Dense evergreen forests of the Western Ghats",
        "seasonal_appearance": [6, 7, 8, 9, 10],
        "conservation_status": "VU",
        "wing_span_min_mm": 120,
        "wing_span_max_mm": 145,
        "is_migratory": False,
        "color_tags": ["black", "green"],
        "host_plants": [
            {"plant_name": "Cinnamon", "plant_scientific_name": "Cinnamomum spp."},
            {"plant_name": "Persea", "plant_scientific_name": "Persea macrantha"},
        ],
        "states": WESTERN_GHATS,
    },
    {
        "common_name": "Kaiser-I-Hind",
        "scientific_name": "Teinopalpus imperialis",
        "family": "Papilionidae",
        "genus": "Teinopalpus",
        "description": (
            "One of India's most prized and protected butterflies. Males have brilliant "
            "apple-green wings; females are larger with blue and gold markings. "
            "Protected under Schedule I of the Wildlife Protection Act. Found in high-altitude "
            "Himalayan forests."
        ),
        "habitat": "High-altitude subtropical and temperate forests (1500–3500m)",
        "seasonal_appearance": [4, 5, 6, 7, 8],
        "conservation_status": "VU",
        "wing_span_min_mm": 90,
        "wing_span_max_mm": 120,
        "is_migratory": False,
        "color_tags": ["green", "gold", "black", "blue"],
        "host_plants": [
            {"plant_name": "Daphne", "plant_scientific_name": "Daphne papyracea"},
            {"plant_name": "Magnolia", "plant_scientific_name": "Magnolia spp."},
        ],
        "states": ["AR", "HP", "MN", "ML", "NL", "SK", "UK", "WB"],
    },
    {
        "common_name": "Nawab",
        "scientific_name": "Polyura athamas",
        "family": "Nymphalidae",
        "genus": "Polyura",
        "description": (
            "A powerful, fast-flying butterfly with pale yellowish-white wings and broad dark borders. "
            "One of the largest and most robust Indian butterflies outside the Papilionidae. "
            "Attracted to rotting fruit, sap, and animal dung rather than flowers."
        ),
        "habitat": "Moist deciduous forests, evergreen forests, hill forests",
        "seasonal_appearance": [4, 5, 6, 7, 8, 9, 10],
        "conservation_status": "LC",
        "wing_span_min_mm": 75,
        "wing_span_max_mm": 95,
        "is_migratory": False,
        "color_tags": ["white", "yellow", "black"],
        "host_plants": [
            {"plant_name": "Acacia", "plant_scientific_name": "Acacia spp."},
            {"plant_name": "Albizia", "plant_scientific_name": "Albizia spp."},
        ],
        "states": ["AP", "AS", "KA", "KL", "MH", "MN", "ML", "OD", "TN", "TS", "WB", "GA"],
    },
    {
        "common_name": "Common Birdwing",
        "scientific_name": "Troides helena",
        "family": "Papilionidae",
        "genus": "Troides",
        "description": (
            "A large and spectacular birdwing butterfly. Males have golden-yellow hindwings "
            "with black forewing. Found in Andaman Islands and parts of Northeast India. "
            "CITES Appendix II listed. Slow, powerful flier staying high in the canopy."
        ),
        "habitat": "Tropical rainforests, forest edges at low to mid elevation",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 140,
        "wing_span_max_mm": 180,
        "is_migratory": False,
        "color_tags": ["black", "yellow", "gold"],
        "host_plants": [
            {"plant_name": "Aristolochia", "plant_scientific_name": "Aristolochia tagala"},
        ],
        "states": ["AN", "AR", "AS", "MN", "ML", "NL", "TR"],
    },
    {
        "common_name": "Burmese Sergeant",
        "scientific_name": "Athyma asura",
        "family": "Nymphalidae",
        "genus": "Athyma",
        "description": (
            "Black wings with a bold white band, similar to the Common Sergeant but "
            "with a characteristic broken sub-marginal white line. Found in Northeast India's forests. "
            "A medium-sized, elegant forest butterfly."
        ),
        "habitat": "Moist evergreen forests, forest margins",
        "seasonal_appearance": [4, 5, 6, 7, 8, 9, 10],
        "conservation_status": "LC",
        "wing_span_min_mm": 55,
        "wing_span_max_mm": 70,
        "is_migratory": False,
        "color_tags": ["black", "white"],
        "host_plants": [
            {"plant_name": "Sterculia", "plant_scientific_name": "Sterculia spp."},
        ],
        "states": ["AR", "AS", "MN", "ML", "MZ", "NL", "TR", "WB"],
    },
    {
        "common_name": "Great Eggfly",
        "scientific_name": "Hypolimnas bolina",
        "family": "Nymphalidae",
        "genus": "Hypolimnas",
        "description": (
            "Males have striking black wings with large white spots ringed with iridescent blue-purple. "
            "Females are highly variable polymorphs that mimic different toxic models. "
            "Found widely across India in gardens and forested areas."
        ),
        "habitat": "Gardens, forest edges, secondary forests, mangroves",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 70,
        "wing_span_max_mm": 95,
        "is_migratory": False,
        "color_tags": ["black", "white", "blue", "purple"],
        "host_plants": [
            {"plant_name": "Portulaca", "plant_scientific_name": "Portulaca oleracea"},
            {"plant_name": "Asystasia", "plant_scientific_name": "Asystasia gangetica"},
        ],
        "states": WIDESPREAD,
    },
    {
        "common_name": "Danaid Eggfly",
        "scientific_name": "Hypolimnas misippus",
        "family": "Nymphalidae",
        "genus": "Hypolimnas",
        "description": (
            "Males are black with white spots; females are an almost perfect mimic of the Plain Tiger. "
            "A textbook example of Batesian mimicry. "
            "Extremely common in open areas and gardens throughout India."
        ),
        "habitat": "Open areas, gardens, grasslands, roadsides, scrubland",
        "seasonal_appearance": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        "conservation_status": "LC",
        "wing_span_min_mm": 65,
        "wing_span_max_mm": 80,
        "is_migratory": False,
        "color_tags": ["black", "white", "orange"],
        "host_plants": [
            {"plant_name": "Portulaca", "plant_scientific_name": "Portulaca spp."},
            {"plant_name": "Convolvulus", "plant_scientific_name": "Ipomoea spp."},
        ],
        "states": WIDESPREAD,
    },
]
