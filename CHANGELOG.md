## v1.0.0 2015-07-14

The API has been rewritten to support immutability of all instances.

## Added

* `Informator::Publisher` base class for immutable publishers (nepalez).
* `Informator::Event#publisher` method to check the source of the event (nepalez).
* `Informator::Event#message` to provide human-readable description on the fly instead legacy `#messages` (nepalez).
* `Informator::Event#time` for the time of event creation (nepalez).
* All classes: `Publisher`, `Subscriber`, `Event` become comparable (nepalez).
* Support for rubies 1.9.3+ (was 2.1+ only) (nepalez).

## Changed

* `Informator::Publisher#publish` publishes the event immediately (nepalez).
* `Informator::Publisher#subscribe` returns a new publisher instead of mutating the existing one (nepalez).

## Deleted

* `Informator` legacy API (including the module doesn't supported any more) (nepalez).
* `Informator::Publisher#memoize` (nepalez).
* `Informator::Event#messages` (nepalez).

## Internal

* Drop internal `Informator::Reporter` class, because no memoization supported any longer (nepalez).
* 100% mutant covered (nepalez).

[Compare v0.1.0...v1.0.0](https://github.com/nepalez/informator/compare/v0.1.0...v1.0.0)

## v0.1.0 2015-07-12

### Changed (backward-incompatible)

* Renamed event-carried `data` to `attributes` (nepalez)

### Internal

* Switched to `ice_nine` gem to freezing objects deeply (nepalez)
* Switched to `hexx-suit` v2.3+ and `hexx-rspec` v0.5+ (nepalez)

[Compare v0.0.2...v0.1.0](https://github.com/nepalez/informator/compare/v0.0.2...v0.1.0)
