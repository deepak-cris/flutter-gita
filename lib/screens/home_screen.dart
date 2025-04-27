import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:bhagavad_gita_simplified/screens/chapter_list_screen.dart';
import 'package:bhagavad_gita_simplified/screens/chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late String randomQuote;
  final List<String> quotes = [
    "You have the right to work, but never to the fruit of work.",
    "The soul is neither born, nor does it die.",
    "When meditation is mastered, the mind is unwavering like the flame of a lamp in a windless place.",
    "Perform your duty equipoised, abandoning all attachment to success or failure.",
    "The self is the friend of the self for he who has conquered himself by the self.",
    "He who sees Me everywhere and sees everything in Me, to him I am never lost, nor is he lost to Me.",
    "There is neither this world nor the world beyond for the sage who is liberated from joy and sorrow.",
    "The wise work for the good of the world, without thought for themselves.",
    "Seek this wisdom by doing service, by strong search, by questions, and by humility.",
    "Whatever you do, offer it to Me, and thus be free from the bondage of actions.",
    "The mind is restless and difficult to restrain, but it is subdued by practice.",
    "He who has no attachments can truly love others, for his love is pure and divine.",
    "Abandon all varieties of religion and just surrender unto Me.",
    "The senses are superior to the body, the mind superior to the senses, and the soul superior still.",
    "Those who fix their minds on Me and worship Me with faith, I consider them perfect in yoga.",
    "The impermanent has no reality; reality lies in the eternal.",
    "He who is temperate in eating, sleeping, work, and recreation attains yoga.",
    "Better indeed is knowledge than mechanical practice; better than knowledge is meditation.",
    "Delusion arises from anger; the mind is bewildered by delusion.",
    "To the soul that has conquered desire, pleasure and pain are alike.",
    "I am the same to all beings; there is none hateful or dear to Me.",
    "The yogi who is satisfied with knowledge and wisdom remains unshaken.",
    "Change is the law of the universe; what you think of as death is indeed life.",
    "He who has faith has wisdom; he who has wisdom finds peace.",
    "Perform all actions as an offering to Me, free from desire and attachment.",
    "The wise see no difference between a learned scholar and a humble devotee.",
    "The self-controlled soul, moving among sense objects with senses under restraint, is free from attachment.",
    "I am the beginning, middle, and end of all beings.",
    "He who sees inaction in action and action in inaction is wise among men.",
    "The power of God is with you at all times; through the activities of mind, senses, and breath.",
    "Seek Me in the heart of all beings, for I dwell there eternally.",
    "The disciplined mind brings happiness; the undisciplined mind brings sorrow.",
    "No one who does good work will ever come to a bad end, either here or in the world to come.",
    "Those who worship Me with devotion live in Me, and I in them.",
    "The body is temporary, but the soul within is eternal and indestructible.",
    "He who has let go of hatred and ego finds peace within and without.",
    "I am time, the destroyer of worlds, and I have come to engage all people.",
    "The wise grieve neither for the living nor for the dead.",
    "Yoga is the journey of the self, through the self, to the self.",
    "The senses are like wild horses; the mind must rein them in.",
    "Act without selfish motives, and you will find liberation in action.",
    "The unreal has no existence; the real never ceases to be.",
    "He who knows Me as the unborn and beginningless finds true freedom.",
    "The soul is beyond the reach of the sword, fire, water, and wind.",
    "Fix your mind on Me alone, and you shall overcome all difficulties.",
    "Those who see Me in all and all in Me are never apart from Me.",
    "The wise unite their consciousness with Mine, transcending the material world.",
    "Work done with selfish desire is far inferior to work done with detachment.",
    "He who has faith and devotion obtains the fruit of his actions.",
    "I am the source of all; from Me everything evolves.",
    "The mind acts like an enemy to those who do not control it.",
    "Seek refuge in Me, and I shall liberate you from all sins.",
    "The yogi sees equality in all beings, both in joy and in sorrow.",
    "Knowledge is the purifier, and action is its means.",
    "The self-realized soul sees the divine in every creature.",
    "He who is unattached to the fruits of his work lives in eternal peace.",
    "I am the strength of the strong, devoid of passion and desire.",
    "The ignorant work for their own profit; the wise work for the welfare of all.",
    "Even a little of this yoga protects one from great fear.",
    "He who has conquered his mind finds Me within himself.",
    "The eternal in man cannot be killed; the temporal alone perishes.",
    "Devote yourself to Me, and you shall come to Me without fail.",
    "The wise see knowledge and action as one; they see truly.",
    "I am the taste of water, the light of the sun and moon.",
    "He who offers Me a leaf, a flower, fruit, or water with devotion, I accept it.",
    "The soul travels from body to body, as a man discards worn-out clothes.",
    "Those who follow this imperishable path of yoga attain Me.",
    "The mind purified by wisdom sees the divine everywhere.",
    "Act for the sake of action, not for its rewards.",
    "I am the syllable Om, the sound in ether, the essence of all Vedas.",
    "He who is free from desire and anger finds liberation in this life.",
    "The supreme truth exists within all beings, unchanging and eternal.",
    "Those who worship Me with love, I guide them to the eternal path.",
    "The senses distract, but the soul remains steady in the wise.",
    "I am the goal, the sustainer, the master, the witness, the abode.",
    "He who sees Me as the supreme Lord finds peace everlasting.",
    "The disciplined soul enjoys pleasures without being bound by them.",
    "Knowledge of the self is the highest wisdom; ignorance binds the soul.",
    "I am the heat in fire, the life in all beings.",
    "The wise surrender the fruits of action and find freedom.",
    "He who knows Me as the enjoyer of sacrifices attains the supreme.",
    "The soul is the eternal witness, beyond birth and death.",
    "Perform your duties with faith, and I shall protect you always.",
    "The yogi who sees all beings in Me finds unity in diversity.",
    "I am the father of this universe, the mother, the support, and the grandsire.",
    "He who is free from delusion knows Me as the eternal reality.",
    "The path of devotion leads to Me; the path of knowledge reveals Me.",
    "The wise do not grieve for what is impermanent.",
    "I am the wisdom of the wise, the strength of the strong.",
    "He who acts with detachment lives in harmony with the divine.",
    "The soul, clothed in a new body, continues its eternal journey.",
    "Seek Me with a pure heart, and you shall find Me within.",
    "The mind that rests in Me is free from fear and agitation.",
    "I am the seed of all existence; nothing moves without Me.",
    "He who knows the self knows Me, for I am the self of all.",
    "The wise offer all actions to Me and find eternal peace.",
    "Yoga is the art of living with skill in action.",
    "I am the eternal refuge; surrender to Me and be free.",
  ];

  @override
  void initState() {
    super.initState();
    final random = Random();
    randomQuote = quotes[random.nextInt(quotes.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bhagavad Gita Simplified'),
        elevation: 2,
        backgroundColor: Colors.orange[800],
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [Colors.orange[100]!, Colors.white],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Takes only necessary height
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FadeInDown(
                  duration: const Duration(milliseconds: 500),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Text(
                      '"$randomQuote"',
                      style: GoogleFonts.hind(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.orange[900],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  delay: const Duration(milliseconds: 200),
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.orange[200]!, width: 1),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChatScreen(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.orange[100],
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.chat_bubble,
                                  color: Colors.orange[800],
                                  size: 30,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Chat with Krishna AI Avatar',
                                    style: GoogleFonts.hind(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange[900],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Ask questions and get insights',
                                    style: GoogleFonts.hind(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.orange[800],
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  delay: const Duration(milliseconds: 400),
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.orange[200]!, width: 1),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChapterListScreen(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.orange[100],
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.menu_book,
                                  color: Colors.orange[800],
                                  size: 30,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Read Gita',
                                    style: GoogleFonts.hind(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange[900],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Explore chapters and verses',
                                    style: GoogleFonts.hind(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.orange[800],
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
