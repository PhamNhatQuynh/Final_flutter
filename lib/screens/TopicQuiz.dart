import 'dart:async';

import 'package:final_quizlet_english/blocs/community/TopicRanking.dart';
import 'package:final_quizlet_english/blocs/community/TopicRankingBloc.dart';
import 'package:final_quizlet_english/blocs/topic/Topic.dart';
import 'package:final_quizlet_english/blocs/topic/TopicDetailBloc.dart';
import 'package:final_quizlet_english/dtos/TopicInfo.dart';
import 'package:final_quizlet_english/models/TopicResultRecord.dart';
import 'package:final_quizlet_english/models/TopicTypeSetting.dart';
import 'package:final_quizlet_english/models/VocabStatus.dart';
import 'package:final_quizlet_english/screens/ResultScreen.dart';
import 'package:final_quizlet_english/screens/TopicType.dart';
import 'package:final_quizlet_english/services/TopicResultRecordDao.dart';
import 'package:final_quizlet_english/services/TypeSettingsDao.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:toggle_switch/toggle_switch.dart';

class TQuizPage extends StatefulWidget {
  const TQuizPage({super.key, required this.topicDTO, required this.userId});

  final TopicInfoDTO topicDTO;
  final String userId;
  // final QuizSettings? settings;

  @override
  State<TQuizPage> createState() => _TQuizPageState();
}

class QuestionModel {
  VocabularyStatus vocabStatus;
  String? question;
  List<Map<String, bool>>? answers;
  QuestionModel(this.question, this.answers, this.vocabStatus);
}

class _TQuizPageState extends State<TQuizPage> {
  List<QuestionModel> questions = [
    // QuestionModel(
    //   "Quynh",
    //   {
    //     "Xinh": false,
    //     "Qua xinh": false,
    //     "Xinh qua": true,
    //     "Xinh xinhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhaaaaaaaaaaaaaaaaaaa": false,
    //   },
    // ),
    // QuestionModel("When does a cat purr ?", {
    //   "When it cares for its kittens": false,
    //   "When it needs confort": false,
    //   "When it feels content": false,
    //   "All of the above": true,
    // }),
    // QuestionModel("What is the averge nulber of kittens in a litter ?", {
    //   "1 to 2": false,
    //   "3 to 5": true,
    //   "8 to 10": false,
    //   "12 to 14": false,
    // }),
    // QuestionModel("How many moons does Mars have ?", {
    //   "1": false,
    //   "2": false,
    //   "4": true,
    //   "8": false,
    // }),
    // QuestionModel("What is Mars's nickname ?", {
    //   "The red planet": true,
    //   "The dusty planet": false,
    //   "The hot planet": false,
    //   "The smelly planet": false,
    // }),
    // QuestionModel("About How long would it take to travel to Mars ?", {
    //   "Three days": false,
    //   "A month": false,
    //   "Eight months": true,
    //   "Two years": false,
    // }),
    // QuestionModel(
    //     "Mars is Named after the Roman god Mars. What is he the god of ?", {
    //   "Fire": false,
    //   "Love": false,
    //   "Agriculture": false,
    //   "War": true,
    // }),
    // QuestionModel("Mars Is the ___ planet from the sun ?", {
    //   "Second": false,
    //   "Third": false,
    //   "Fourth": true,
    //   "Sixth": false,
    // }),
    // QuestionModel(
    //     "Where did Orville and Wilbur Wright build their first flying airplane ?",
    //     {
    //       "Paris, France": false,
    //       "Boston, Massachusetts": false,
    //       "Kitty Hawk, North Carolina": true,
    //       "Tokyou, Japan": false,
    //     }),
    // QuestionModel(
    //     "The First astronuts to travel to space came from which country ?", {
    //   "United States": false,
    //   "Soviet Union (now Russia)": true,
    //   "China": false,
    //   "Rocketonia": false,
    // }),
  ];
  List<QuestionModel> reLearnQuestions = [];
  int learning = 0;
  int knew = 0;
  bool isReLearning = false;
  String recordDocId = "";
  late double _initial;
  bool btnPressed = false;
  final PageController _controller = PageController(initialPage: 0);
  String btnText = "Next Question";
  bool answered = false;
  int originalLength = 0;
  List<int> skipQuestions = [];
  FlutterTts flutterTts = FlutterTts();

  bool randomOp = false;
  bool audioPlay = false;
  bool isVietnameseSelected = true;
  bool autoFlip = false;
  void textToSpeechEn(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  void textToSpeechVi(String text) async {
    await flutterTts.setLanguage("vi-VN");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

  // void handleStart() {
  //   if(!stopwatch.isRunning) {
  //     stopwatch.start();
  //   }
  // }
  // void handleStop() {
  //   if(stopwatch.isRunning) {
  //     stopwatch.stop();
  //   }
  // }
  //chuyển hết thời gian sang giây
  int getStopwatchTimeToSeconds() {
    int seconds = _stopwatch.elapsed.inSeconds;
    return seconds;
  }

  void _startTimer() {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {});
      });
    }
  }

  void _stopTimer() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _timer?.cancel();
    }
  }

  void _resetTimer() {
    _stopwatch.reset();
    setState(() {});
  }

  @override
  void initState() {
    _startTimer();

    // t = Timer.periodic(Duration(seconds: 1), (timer) {
    //   setState(() {});
    // });
    var answers = [];
    for (var element in widget.topicDTO.vocabs!) {
      answers.add(element.vocab.definition);
    }
    for (var vocabDTO in widget.topicDTO.vocabs!) {
      var otherAnswer = List.from(answers);
      var vocab = vocabDTO.vocab;
      int index =
          otherAnswer.indexWhere((element) => element == vocab.definition);
      if (index != -1) {
        otherAnswer.removeAt(index);
      }
      // print(otherAnswer);

      otherAnswer.shuffle();
      var answer = [
        {"${otherAnswer[0]}": false},
        {"${otherAnswer[1]}": false},
        {"${otherAnswer[2]}": false},
        {vocab.definition: true},
      ];
      // print(answer);
      answer.shuffle();
      // print(answer);
      questions
          .add(QuestionModel("${vocab.term} ?", answer, vocabDTO.vocabStatus));
    }
    _initial = 1 / questions.length;
    super.initState();

    // for (var i = 0; i < questions.length; i++) {
    //   print(questions[i].answers);
    // }
    originalLength = questions.length;
  }

  @override
  void dispose() {
    _controller.dispose();
    _stopTimer();
    super.dispose();
  }

  shuffleMap(List<Map<dynamic, dynamic>> map) {
    // var entries = map.entries.toList();
    map.shuffle();
    // return Map<String, bool>.fromEntries(map.map((entry) => MapEntry(entry.key.toString(), entry.value as bool)));
  }

  @override
  Widget build(BuildContext context) {
    int noQuestions = questions.length;
    String value = (_initial * noQuestions).toStringAsFixed(0);
    print(getStopwatchTimeToSeconds());
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            color: Colors.grey,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: const Text('Do you want to end this test'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Continue',
                            style: TextStyle(color: Colors.orange)),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => TDetailPage()),
                          // );
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text('End Test',
                            style: TextStyle(color: Colors.lightGreen)),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          title: Text(
            '$value / $noQuestions',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
                fontSize: 20),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.grey,
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 1 / 2,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  const Text(
                                    "Settings",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 40),
                                ],
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Random terms",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                              Text(
                                                "Randomly display terms during the learning",
                                                style: TextStyle(
                                                    color: Colors.grey[700]),
                                              ),
                                            ],
                                          ),
                                          Switch(
                                            value: randomOp,
                                            onChanged: (bool value) {
                                              setState(() {
                                                randomOp = value;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Play audio",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                              Text(
                                                "Automatically play audio upon card opening.",
                                                style: TextStyle(
                                                    color: Colors.grey[700]),
                                              ),
                                            ],
                                          ),
                                          Switch(
                                            value: audioPlay,
                                            onChanged: (bool value) {
                                              setState(() {
                                                audioPlay = value;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "Answer with",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ToggleSwitch(
                                        minWidth:
                                            MediaQuery.of(context).size.width,
                                        minHeight: 35,
                                        initialLabelIndex: 1,
                                        activeBgColor: const [
                                          Colors.lightGreen
                                        ],
                                        activeFgColor: Colors.white,
                                        inactiveBgColor: Colors.white,
                                        inactiveFgColor: Colors.grey[900],
                                        borderColor: const [Colors.green],
                                        borderWidth: 1.5,
                                        totalSwitches: 2,
                                        labels: const ['English', 'Vietnamese'],
                                        onToggle: (index) {
                                          //code sử lý gì á
                                          print('switched to: $index');
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                            onPressed: () {},
                                            child: const Text(
                                              "Restart Quiz",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.lightGreen,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            )
          ],
        ),
        body: Column(
          children: [
            LinearProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: const AlwaysStoppedAnimation(Colors.lightGreen),
              minHeight: 5,
              value: _initial,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: PageView.builder(
                  itemCount: questions.length,
                  controller: _controller,
                  onPageChanged: (page) {
                    if (page == questions.length - 1) {
                      setState(() {
                        btnText = "See Results";
                      });
                    }
                    setState(() {
                      answered = false;
                    });
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (widget.topicDTO.topic.termLanguage ==
                                    "English") {
                                  textToSpeechEn(
                                      questions[index].question.toString());
                                } else {
                                  textToSpeechVi(
                                      questions[index].question.toString());
                                }
                              },
                              icon: const Icon(Icons.volume_up),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Text(
                          "${questions[index].question}",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 22.0,
                          ),
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                        // for (int i = 0;
                        //     i < questions[index].answers!.length;
                        //     i++)
                        SizedBox(
                          height: 300,
                          child: ListView.builder(
                              itemCount: 4,
                              itemBuilder: (context, i) {
                                return Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(
                                      bottom: 20.0, left: 12.0, right: 12.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                      color: btnPressed
                                          ? questions[index]
                                                  .answers![i]
                                                  .values
                                                  .first
                                              ? Colors.lightGreen
                                              : Colors.orange
                                          : Colors.grey,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: TextButton(
                                    // style: ButtonStyle(
                                    //   shape: MaterialStatePropertyAll(

                                    //   ),
                                    // ),
                                    onPressed: !answered
                                        ? () {
                                            if (questions[index]
                                                .answers![i]
                                                .values
                                                .first) {
                                              // score++;
                                              knew++;
                                              //update vocab status
                                              if (questions[index]
                                                      .vocabStatus
                                                      .status !=
                                                  2) {
                                                context
                                                    .read<TopicDetailBloc>()
                                                    .add(
                                                        UpdateVocabStatusStatus(
                                                            questions[index]
                                                                .vocabStatus,
                                                            2)); // knew
                                              }
                                              print("yes");
                                            } else {
                                              //trả lời sai => studying
                                              learning++;
                                              reLearnQuestions
                                                  .add(questions[index]);
                                              if (questions[index]
                                                      .vocabStatus
                                                      .status !=
                                                  1) {
                                                context
                                                    .read<TopicDetailBloc>()
                                                    .add(
                                                        UpdateVocabStatusStatus(
                                                            questions[index]
                                                                .vocabStatus,
                                                            1)); // studying
                                              }
                                              print("no");
                                            }
                                            setState(() {
                                              btnPressed = true;
                                              answered = true;
                                              // updateToNext();
                                            });
                                          }
                                        : null,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            questions[index]
                                                .answers![i]
                                                .keys
                                                .first
                                                .toString(),
                                            style: TextStyle(
                                              color: btnPressed
                                                  ? questions[index]
                                                          .answers![i]
                                                          .values
                                                          .first
                                                      ? Colors.lightGreen
                                                      : Colors.orange
                                                  : Colors.grey,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ),
                                        btnPressed
                                            ? questions[index]
                                                    .answers![i]
                                                    .values
                                                    .first
                                                ? Container(
                                                    height: 30,
                                                    width: 30,
                                                    decoration: BoxDecoration(
                                                      color: Colors.lightGreen,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              60),
                                                    ),
                                                    child: const Icon(
                                                        Icons.check,
                                                        color: Colors.white),
                                                  )
                                                : Container(
                                                    height: 30,
                                                    width: 30,
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              60),
                                                    ),
                                                    child: const Icon(
                                                        Icons.close,
                                                        color: Colors.white),
                                                  )
                                            : Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(60),
                                                  border: Border.all(
                                                      color: Colors.grey,
                                                      width: 2),
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightGreen,
                            foregroundColor: Colors.white,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0)),
                            minimumSize: const Size(200, 50),
                          ),
                          child: Text(
                            btnText,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () async {
                            context.read<TopicRankingBloc>().add(LoadTopicRankings(widget.userId));
                            if (!answered) {
                              skipQuestions.add(_controller.page!.toInt());
                            }

                            if (_controller.page?.toInt() ==
                                questions.length - 1) {
                              _stopTimer();
                              // int notAnswered = questions.length - knew - learning;
                              //saved record
                              int completedTime = getStopwatchTimeToSeconds();
                              if(widget.topicDTO.vocabs!.length == widget.topicDTO.termNumbers){//choi = favorite => khong add vao record
                                if (isReLearning) {
                                var res = await TopicResultRecordDao()
                                    .getTopicResultRecordByDocId(recordDocId);
                                int learning = widget.topicDTO.termNumbers -
                                    knew -
                                    skipQuestions.length;
                                if (res["status"]) {
                                  TopicResultRecord record = res["data"];
                                  record.completedTime = completedTime;
                                  record.correctAnswers = knew;
                                  record.wrongAnswers = learning;
                                  record.notAnswers = skipQuestions.length;
                                  var resUpdate = await TopicResultRecordDao()
                                      .updateTopicResultRecord(record);
                                  print(resUpdate);
                                }
                                print(res["status"]);
                              } else {
                                TopicResultRecord record = TopicResultRecord(
                                    topicId: widget.topicDTO.topic.id!,
                                    userId: widget.userId,
                                    completedTime: completedTime,
                                    correctAnswers: knew,
                                    wrongAnswers: learning,
                                    notAnswers: skipQuestions.length);
                                var res = await TopicResultRecordDao()
                                    .addTopicResultRecord(record);
                                print(res);
                                if (res["status"]) {
                                  setState(() {
                                    recordDocId = res["data"];
                                  });
                                }
                              }
                              }
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ResultScreen(
                                              knew: knew,
                                              learning: learning,
                                              notAnswered: skipQuestions.length,
                                              total: originalLength,
                                              finishTime: completedTime)))
                                  .then((value) async {
                                if (value == "true") {
                                  // print(value);
                                  _resetTimer();
                                  _startTimer();
                                  // _controller.jumpToPage(0);
                                  _controller.jumpTo(0);
                                  setState(() {
                                    knew = 0;
                                    learning = 0;
                                    isReLearning = false;
                                    btnText = "Next Question";
                                    _initial =
                                        1 / widget.topicDTO.vocabs!.length;
                                    btnPressed = false;
                                    answered = false;
                                  });
                                } else if (value == "wrong-question") {
                                  _startTimer();
                                  _controller.jumpTo(0);
                                  if (skipQuestions.isNotEmpty) {
                                    // print(skipQuestions);
                                    for (var index in skipQuestions) {
                                      reLearnQuestions.add(questions[index]);
                                    }
                                  }
                                  skipQuestions = [];
                                  setState(() {
                                    isReLearning = true;
                                    questions = reLearnQuestions;
                                    reLearnQuestions = [];
                                    // print(questions);
                                    if (questions.length == originalLength) {
                                      knew = 0;
                                      learning = 0;
                                    }
                                    noQuestions = questions.length;
                                    btnText = (noQuestions == 1)
                                        ? "See Result"
                                        : "Next Question";
                                    _initial = 1 / noQuestions;
                                    btnPressed = false;
                                    answered = false;
                                  });
                                } else if (value == "to-typing") {
                                  var result = await TypeSettingsDao()
                                      .getTypeSettingsByUserId(
                                          widget.topicDTO.topic.userId);
                                  if (result["status"]) {
                                    TopicTypeSettings tSettings =
                                        TopicTypeSettings.fromJson(
                                            result["data"]);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TypingPractice(
                                                    topic: widget.topicDTO,
                                                    tSettings: tSettings)));
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TypingPractice(
                                                    topic: widget.topicDTO)));
                                  }
                                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TypingPractice(topic: widget.topicDTO,)));
                                } else {
                                  Navigator.pop(context);
                                }
                              });
                            } else {
                              _controller.nextPage(
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeInExpo);
                              // if(!answered){
                              //   skipQuestions.add(_controller.page!.toInt());
                              // }
                              setState(() {
                                btnPressed = false;
                                updateToNext();
                              });
                            }
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ));
  }

  void updateToNext() {
    setState(() {
      _initial = _initial + 1 / questions.length;
      if (_initial > 1.0) {
        _initial = 1 / questions.length;
      }
    });
  }
}
