# Contributing to Flutter_Firebase

First off, thank you for taking the time to contribute!

The following is a set of guidelines for contributing to Flutter_Firebase on GitHub. These are mostly guidelines, not rules. Use your best judgment, and feel free to propose changes to this document in a pull request.

## Code of Conduct

This project and everyone participating in it is governed by the [Contributor Covenant Code of Conduct](./CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to the [admin](mailto:iamyubinkarki@gmail.com).

## How Can I Contribute?

### Reporting Bugs

This section guides you through submitting a bug report for Flutter_Firebase. Following these guidelines helps maintainers and the community understand your report, reproduce the behavior, and find related reports.

Before creating bug reports, please check [this list](#before-submitting-a-bug-report) as you might find out that you don't need to create one. When you are creating a bug report, please [include as many details as possible](#how-do-i-submit-a-good-bug-report). Fill out [the required template](./issue_template/BUG_REPORT.md), the information it asks for helps us resolve issues faster.

> **Note:** If you find a **Closed** issue that seems like it is the same thing that you're experiencing, open a new issue and include a link to the original issue in the body of your new one.

#### Before Submitting A Bug Report

- Check if you can reproduce the problem.
- Determine which branch the problem was detected.
- Perform a [cursory search](https://github.com/yubinkarki/Flutter_Firebase/issues) to see if the problem has already been reported. If it has **and the issue is still open**, add a comment to the existing issue instead of opening a new one.

#### How Do I Submit A (Good) Bug Report?

Bugs are tracked as [GitHub issues](https://github.com/features/issues). After you've determined the nature of the problem, create an issue and provide the following information by filling in [the template](./issue_template/BUG_REPORT.md).

Explain the problem and include additional details to help maintainers reproduce the problem:

- Use a clear and descriptive title for the issue to identify the problem.
- Describe the exact steps which reproduce the problem in as many details as possible. For example, start by explaining how you started Flutter_Firebase, e.g. which command exactly you used in the terminal.
- Describe the behavior you observed after following the steps and point out what exactly is the problem with that behavior.
- Explain which behavior you expected to see instead and why.
- If the problem is related to performance or memory, include a CPU profile capture with your report.

Provide more context by answering these questions:

- Can you reproduce the problem in **debug mode**?
- Did the problem start happening recently (e.g. after updating to a new version) or was this always a problem?
- If the problem started happening recently, can you reproduce the problem in an older version of Flutter_Firebase? What's the most recent version in which the problem doesn't happen? You can download older versions of Flutter_Firebase from [tags](https://github.com/yubinkarki/Flutter_Firebase/tags) list.
- Can you reliably reproduce the issue? If not, provide details about how often the problem happens and under which conditions it normally happens.

Include details about your configuration and environment:

- Which version of Flutter_Firebase are you using? You can get the exact version from _pubspec.yaml_ file.
- On which device are you running the app? OS, Brand, Model and UI (Eg: One UI, Oxygen OS, MIUI).
- Are you running the app in a simulator? If so, specify the details.

### Suggesting Enhancements

This section guides you through submitting an enhancement suggestion for Flutter_Firebase, including completely new features and minor improvements to existing functionality. Following these guidelines helps maintainers and the community understand your suggestion and find related suggestions.

Before creating enhancement suggestions, please check [this list](#before-submitting-an-enhancement-suggestion) as you might find out that you don't need to create one. When you are creating an enhancement suggestion, please [include as many details as possible](#how-do-i-submit-a-good-enhancement-suggestion). Fill in [the template](./ISSUE_TEMPLATE/FEATURE_REQUEST.md), including the steps that you imagine you would take if the feature you're requesting existed.

#### Before Submitting An Enhancement Suggestion

- Check if you're using the latest version of Flutter_Firebase _(compare from the latest tag version)_.
- Check if there's already [a package](https://pub.dev/) which provides that enhancement.
- Perform a [cursory search](https://github.com/yubinkarki/Flutter_Firebase/issues) to see if the enhancement has already been suggested. If it has, add a comment to the existing issue instead of opening a new one.

#### How Do I Submit A (Good) Enhancement Suggestion?

Enhancement suggestions are tracked as [Github issues](https://github.com/features/issues). After you've determined your enhancement, create an issue and provide the following information:

- Use a clear and descriptive title for the issue to identify the suggestion.
- Provide a step-by-step description of the suggested enhancement in as many details as possible.
- Describe the current behavior and explain which behavior you expected to see instead and why.
- Include screenshots and animated GIFs which help you demonstrate the steps or point out the part of the app which the suggestion is related to.
- Specify which version of Flutter_Firebase you're using. You can find the version number in _pubspec.yaml_ file.

### Pull Requests

The process described here has several goals:

- Maintain Flutter_Firebase's quality.
- Fix problems that are important to users.
- Engage the community in working toward the best possible version of the app.
- Enable a sustainable system for Flutter_Firebase's maintainers to review contributions.

Please follow these steps to have your contribution considered by the maintainers:

1. Follow all instructions in [the template](./PULL_REQUEST_TEMPLATE.md).
2. Follow appropriate [style guides](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo) and [proper commit conventions](https://www.conventionalcommits.org/en/v1.0.0/).
3. After you submit your pull request, verify that all [status checks](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/collaborating-on-repositories-with-code-quality-features/about-status-checks) are passing. <details><summary>What if the status checks are failing?</summary>If a status check is failing, and you believe that the failure is unrelated to your change, please leave a comment on the pull request explaining why you believe the failure is unrelated. A maintainer will re-run the status check for you. If we conclude that the failure was a false positive, then we will open an issue to track that problem with our status check suite.</details>
4. Follow proper [branching strategy](https://medium.com/@yubinkarki/git-branching-strategy-617e8b73c8e3). Checkout from the default branch to start working.

While the prerequisites above must be satisfied prior to having your pull request reviewed, the reviewer(s) may ask you to complete additional design work, tests, or other changes before your pull request can be ultimately accepted.

## Additional Notes

### Issue and Pull Request Labels

This section lists the labels we use to help us track and manage issues and pull requests. The labels are loosely grouped by their purpose and an issue can have <= 5 labels.

Please open an issue if you have suggestions for new labels, and if you notice some labels are missing on some repositories, then please open an issue.

| Label name                | Description                                                                                                |
| ------------------------- | ---------------------------------------------------------------------------------------------------------- |
| `enhancement`             | New feature requests.                                                                                      |
| `bug`                     | Confirmed bugs or reports that are very likely to be bugs.                                                 |
| `duplicate`               | Issues which are duplicates of other issues, i.e. they have been reported before.                          |
| `invalid`                 | Issues which are not valid.                                                                                |
| `more-information-needed` | More information needs to be collected about these problems or feature requests (e.g. steps to reproduce). |
| `android`                 | Related to the Android operating system.                                                                   |
| `ios`                     | Related to iOS.                                                                                            |
| `documentation`           | Related to any kind of documentation.                                                                      |
| `security`                | Related to any kind of security.                                                                           |
| `in-progress`             | Currently being worked on by someone.                                                                      |
| `under-review`            | Pull requests which is under review.                                                                       |
| `needs-review`            | Pull requests which needs code review, and approval from maintainers.                                      |
| `ui`                      | Related to the user interface.                                                                             |
| `backlog`                 | Tickets ready to be worked on.                                                                             |

## Maintainers of Flutter_Firebase

We are thankful for our maintainers who are always looking out for the project. Feel free to reach out to them if you have any queries not satisfied by this document.

[Yubin Karki](mailto:iamyubinkarki@mail.com)  
