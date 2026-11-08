# 04 — Incident response plan and tabletop exercise

**Artefacts:**
- [Incident Response Plan v1.1 — Google Doc (view only)](https://docs.google.com/document/d/1LLZzONcNENcnrn1ZdpWsJJ8o0zdj9VRLMbrmsmXoKzc/edit?usp=sharing)
- [Tabletop exercise TTX-01 and incident report — Google Doc (view only)](https://docs.google.com/document/d/17ro6JKg-mW8UctqNQYahEoc5ifCOoTP_XN6T1r5euJU/edit?usp=sharing)

> Simulated engagement. The plan is adapted from my own [Oscorp incident response plan](https://github.com/frankremmy/grc-mastery/blob/main/deliverables/08-oscorp-incident-response-plan.md), which follows the ENISA incident management guide. I reviewed it against the public templates in the GRC Mastery course, used with the course owner's permission. The scenario, exercise and findings are my own.

## What's here

**The plan (5 pages)** covers:
- duties, including GDPR as controller *and* as processor, a NIS2 check, contracts and the insurer
- four severity levels, with automatic triggers for raising severity
- roles, with a named deputy for each
- a five-step response process
- the communications rules
- five playbooks
- testing commitments

It's written for decisions and deadlines. The technical steps are in the playbooks.

**The exercise (5 pages)** tests the plan against **R-01**, the top risk in the [risk register](../02-risk-register/): a developer pushes a long-lived AWS key to a public repository, and it's used to read customer invoice exports. The document has four parts:

1. **Design.** Objectives, participants, background, and 7 timed injects, each with the questions put to the team.
2. **What the team decided.** Every decision with its time, who made it, and my assessment as facilitator.
3. **Incident report.** Written as if the incident were real: timeline, scope, root cause and notifications.
4. **Lessons and actions.** 8 actions, each with an owner and date, mapped to SoA controls and to risks.

## What the exercise found

| | |
|---|---|
| Time to contain once discovered | **16 minutes** (key deactivated and kept as evidence) |
| Time to discover | **54 hours**. The AWS notice went to a shared mailbox nobody watched at weekends |
| Scope | **Could not be proven.** S3 data events were off, so all 1,842 files from 312 customers had to be treated as read |
| GDPR | Ardent was the **processor**. It owed its 312 customers notice within 48 hours, and did not notify the IDPC directly. Plan v1.0 got this wrong, and the DPO had to work it out live |
| Customer notices | Sent within the 48-hour contractual window |

**The plan changed because of the exercise.** Version 1.1 adds:
- a controller/processor section
- an "assume accessed" rule for when logs are missing
- a monitored AWS security contact
- pre-approved customer messages

The document control table records each change, and links it to the lesson that caused it.

## Why it's built this way

- **One scenario, tied to the top risk.** A tabletop pays for itself when it tests the incident the organisation most needs to handle well. Here that's the one the FAIR estimate put at about €231k a year.
- **The ISM facilitates, and the deputy runs the response.** If the plan only works when its author is in the room, it hasn't been tested.
- **Controller vs processor.** For a B2B SaaS company this is the most common GDPR mistake. Most of the personal data Ardent holds belongs to its customers' customers, so Ardent's duty is to tell its customers quickly and give them what they need to make their own Art. 33 decision.
- **Lessons go back into the registers.** Each action links to an SoA control and a risk ID. The internal audit ([project 07](../07-internal-audit/)) then checks whether they actually happened.
