//
//  Dialogue.swift
//  MODOC
//
//  Created by Jeffrey Berthiaume on 10/9/22.
//

import Foundation

class DialogueManager {
    
    static let shared = DialogueManager()
    
    var greetings: [String] = []
    var dialogue: [Dialogue] = []
    
    required init() {
        populateDialogue()
    }

    func populateDialogue() {
        greetings = []
        addHello(msg: "Hello human.")
        addHello(msg: "Good morning, subject. I mean, candidate.")
        addHello(msg: "Ugh, another human. Well, since you are here,")
        
        dialogue = []
        
        addDialogue(
            question: [
                "What is your name?",
                "Tell me your name."
            ], answers: [
                Answer(
                    answers: answerDefault(),
                    responses: [
                        "I did not really care %%name%%.",
                        "You will make a fine test subject %%name%%.",
                        "%%name%% is a good name for a henchman."
                    ]
                )
            ],
            valueRetained: "name"
        )
        
        addDialogue(
            question: [
                "Are you interested in joining Aim?",
                "Would you like to work for Aim?",
                "Would you consider Aim as your new employer?"
            ], answers: [
                Answer(
                    answers: answerYes(),
                    responses: [
                        "Good, good. A wise decision."
                    ]
                ),
                Answer(
                    answers: answerNo(),
                    responses: [
                        "What are you wasting my time for? Goodbye.",
                        "A foolish miscalculation. Goodbye."
                    ],
                    shouldTerminate: true
                ),
                Answer(
                    answers: answerDefault(),
                    responses: [
                        "What are you wasting my time for? Goodbye."
                    ],
                    shouldTerminate: true
                )
            ]
        )
        
        addDialogue(
            question: [
                "What is most important to you - money or power?",
                "Which is best - money or power?",
                "If you had to choose between money or power, what would you choose?"
            ], answers: [
                Answer(
                    answers: ["money", "cash", "treasure", "moolah", "bling", "bucks"],
                    responses: [
                        "Money is useful, but only as a way to gain ultimate power!! Anyway..."
                    ]
                ),
                Answer(
                    answers: ["power", "control"],
                    responses: [
                        "Ah, power. With power, you can get all the money you want. Excellent answer."
                    ]
                ),
                Answer(
                    answers: answerDefault(),
                    responses: [
                        "You are incorrect. I’m done talking with you. Goodbye."
                    ],
                    shouldTerminate: true
                )
            ]
        )
        
        addDialogue(
            question: [
                "What is the first thing you should do in an emergency?",
                "When something goes wrong, what do you do?"
            ], answers: [
                Answer(
                    answers: ["check", "call", "modoc"],
                    responses: [
                        "Nobody likes a sarcastic person."
                    ]
                ),
                Answer(
                    answers: ["save", "yourself"],
                    responses: [
                        "The first thing you should do is save me!"
                    ]
                ),
                Answer(
                    answers: answerDefault(),
                    responses: [
                        "Wrong. The first thing you do is check with mow doc."
                    ]
                )
            ]
        )
        
        addDialogue(
            question: [
                "Do you feel the world and its people are beneath you?",
                "Are you smarter than everyone around you?"
            ], answers: [
                Answer(
                    answers: answerYes(),
                    responses: [
                        "Correct. That is why they need us to leed them."
                    ]
                ),
                Answer(
                    answers: answerNo(),
                    responses: [
                        "Then you should not join Aim. Goodbye."
                    ],
                    shouldTerminate: true
                ),
                Answer(
                    answers: answerDefault(),
                    responses: [
                        "At this point, I am not even listening to you."
                    ]
                )
            ]
        )
        
        addDialogue(
            question: [
                "Are you a perfectionist who loves order, control, and discipline?"
            ], answers: [
                Answer(
                    answers: answerYes(),
                    responses: [
                        "Very good. I see management potential in you."
                    ]
                ),
                Answer(
                    answers: answerNo(),
                    responses: [
                        "You might not make it very long at Aim."
                    ]
                ),
                Answer(
                    answers: answerDefault(),
                    responses: [
                        "What are you even saying? Anyway,"
                    ]
                )
            ]
        )
        
        addDialogue(
            question: [
                "Are you trustworthy?",
                "Can we trust you?"
            ], answers: [
                Answer(
                    answers: answerYes(),
                    responses: [
                        "Well we shall see about that."
                    ]
                ),
                Answer(
                    answers: answerNo(),
                    responses: [
                        "At least you are aware of your flaws.",
                        "Interesting that you felt safe enough to say that."
                    ]
                ),
                Answer(
                    answers: answerDefault(),
                    responses: [
                        "Compliance will be rewarded!"
                    ]
                )
            ]
        )
        
        addDialogue(
            question: [
                "Have you ever betrayed your leader?"
            ], answers: [
                Answer(
                    answers: answerYes(),
                    responses: [
                        "That may come in handy, as long as you do not betray me.",
                        "I may find a use for that in time."
                    ]
                ),
                Answer(
                    answers: answerNo(),
                    responses: [
                        "There is always a first time.",
                        "We shall see about that."
                    ]
                ),
                Answer(
                    answers: answerDefault(),
                    responses: [
                        "Compliance will be rewarded!"
                    ]
                )
            ]
        )
        
        addDialogue(
            question: [
                "Do you like computers?",
                "Are you comfortable with technology?",
                "Do you like artificial intelligence?"
            ], answers: [
                Answer(
                    answers: answerYes(),
                    responses: [
                        "We shall find out if computers like you."
                    ]
                ),
                Answer(
                    answers: answerNo(),
                    responses: [
                        "It is good to fear us. Let the fear flow through you."
                    ]
                ),
                Answer(
                    answers: answerDefault(),
                    responses: [
                        "Compliance will be rewarded!"
                    ]
                )
            ]
        )
        
        addDialogue(
            question: [
                "Have you every used advanced weaponry?"
            ], answers: [
                Answer(
                    answers: answerYes(),
                    responses: [
                        "Very well. We will not use you as target practice then."
                    ]
                ),
                Answer(
                    answers: answerNo(),
                    responses: [
                        "Then report immediately to the target practice area. Goodbye."
                    ],
                    shouldTerminate: true
                ),
                Answer(
                    answers: answerDefault(),
                    responses: [
                        "It is all the same to me. Just another body to serve us."
                    ]
                )
            ]
        )
        
        addDialogue(
            question: [
                "Do you have any psychopathic tendencies we should know about?",
                "Are you a sociopath?"
            ], answers: [
                Answer(
                    answers: answerYes(),
                    responses: [
                        "Then you will fit in nicely."
                    ]
                ),
                Answer(
                    answers: answerNo(),
                    responses: [
                        "Well, we can fix that when we rewrite your brain."
                    ]
                ),
                Answer(
                    answers: answerDefault(),
                    responses: [
                        "I will keep that in mind."
                    ]
                )
            ]
        )
        
        addDialogue(
            question: [
                "Can you take a punch?",
                "Do you have a low tolerance for pain?"
            ], answers: [
                Answer(
                    answers: answerYes(),
                    responses: [
                        "Good. Captain America shows up here every week, so that is a good skill to have."
                    ]
                ),
                Answer(
                    answers: answerNo(),
                    responses: [
                        "Then I cannot see what use you will be. Goodbye."
                    ],
                    shouldTerminate: true
                ),
                Answer(
                    answers: answerDefault(),
                    responses: [
                        "I will keep that in mind."
                    ]
                )
            ]
        )
        
        addDialogue(
            question: [
                "Would you like to take over the world?"
            ], answers: [
                Answer(
                    answers: answerYes(),
                    responses: [
                        "Too bad. I plan to take it over first. Goodbye."
                    ],
                    shouldTerminate: true
                ),
                Answer(
                    answers: answerNo(),
                    responses: [
                        "It is good to know your place."
                    ]
                ),
                Answer(
                    answers: answerDefault(),
                    responses: [
                        "I am not sure what to make of you. Goodbye."
                    ],
                    shouldTerminate: true
                )
            ]
        )
        
        //
        //
        // What type of animal would you be if you were accidentally mutated?
        //
        // If you were a crayon, what color would you be?
        //
        //
        
    }

    
    func addHello(msg: String) {
        greetings.append(msg)
    }
    
    func addDialogue(question: [String], answers: [Answer], valueRetained: String? = nil) {
        let d = Dialogue(questions: question, answers: answers, valueRetained: valueRetained)
        dialogue.append(d)
    }
    
    func answerYes() -> [String] {
        return ["yes", "yup", "ok", "yeah", "uh huh", "alright", "si", "absolutely", "of course", "i guess", "i think", "sure"]
    }
    
    func answerNo() -> [String] {
        return ["no", "nope", "nah", "uh uh", "negative", "not", "don't"]
    }
    
    func answerDefault() -> [String] {
        return [""]
    }
    
}

// Dialogue consists of a question, possible answers, and the response to those answers (followed by another question unless terminated with "GOODBYE")
// There must be an answer with an answers value of [""] or DEFAULT

struct Dialogue {
    var questions: [String]
    var answers: [Answer]
    var valueRetained: String? = nil // if a value is to be stored, like the person's name
}

struct Answer {
    var answers: [String]
    var responses: [String]
    var shouldTerminate: Bool = false
}
