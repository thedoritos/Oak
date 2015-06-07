# Oak

[![Build Status](https://travis-ci.org/thedoritos/Oak.svg?branch=develop)](https://travis-ci.org/thedoritos/Oak)

Calendar app for the super limited situation.

![break](assets/homemade_wheat_bread.jpg)

## Build

### Google API Client ID

- Download Google API Client ID from Google Developer Console in JSON format
- Place the JSON on `Config/client_secret.json`

## Testing

### Unit Tests

```
xcodebuild test -workspace Oak.xcworkspace -scheme Oak -sdk iphonesimulator
```

### Acceptance Tests

```
bundle install --path=vendor/bundle
bundle exec cucumber
```