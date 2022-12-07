## [0.3.4] - 2022-12-07

feat(dataStreamHelper):
- `it.next` accept iterable
- `it.done` accept data iterable
- `dataStreamWrapper` accept iterable
deps:
- bump slang to 3.5.0

## [0.3.3] - 2022-11-03

deps:
- bump slang to 3.3.0

## [0.3.2] - 2022-08-29

feat(localization):
- migrate localization to slang, export sliverStreamBuilderLocalization

## [0.3.1] - 2022-08-16

feat(logs):
- logs error from SliverStreamBuilder in debug mode
fix:
- example build

## [0.3.0] - 2022-08-14

feat(helper):
- add data stream helper to prevent missuse and simplify work with state

## [0.2.1] - 2022-08-03

fix: 
- dataStreamWrapper stalling next function

## [0.2.0] - 2022-05-06

feat:
- change error builder signature 

## [0.1.2] - 2022-02-20

fix: 
- default text extractor return invalid data

## [0.1.1] - 2022-04-19

fix:
- dataStreamWrapper now close stream on data ends

## [0.1.0] - 2022-02-08

feat:
- change error processing, now can define custom onErrorRetry function
- add stackTrace preserve
- add key param to sliver builder
- imporve data stream wrapper

fix: 
- data clean on any widget changes


## [0.0.6] - 2021-12-18

bugfix:
- fix unreproducable in tests bug that display progress indicator after done event

## [0.0.5] - 2021-12-04

- add dataStreamWrapper for easy loader creation
- fix: add padding to default progress indicator

## 0.0.4
- add keepOldDataOnLoading behavior

## 0.0.3
- some test and examples

## 0.0.2+1
- fix lock on empty builder

## 0.0.2
- initial release.
