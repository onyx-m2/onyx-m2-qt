This is part of the [Onyx M2 Project](https://github.com/onyx-m2), which enables
read-only real-time access to the Tesla Model 3/Y CAN bus data, including the
ability to run apps on the car's main screen through its built in web browser.

This project is a little different as it requires a direct connection to the canbus.
The intent is to run this as an electronic instrument cluster (EIC) on a Raspberry Pi
with some sort of CAN HAT that gives access to the car's data.

In my own implementation, I use the diagnostics connector behind the passenger kick
panel, and have the hard wired to the Pi mounted behind the steering wheel.

**NOTE: Proper documentation is forthcoming (you know, "soon")**

## Build & Install

```
git clone --recurse-submodules https://github.com/onyx-m2/onyx-m2-qt
```

Then it's complicated... will clean up and document "soon".

## Random Notes

- The DBC in this repo is the same as [Onyx M2 DBC](https://github.com/onyx-m2/onyx-m2-dbc)
  but without the `VAL_` entries because the library I'm using take ages to parse that
  stuff and this app doesn't use any of that data.

- To build the C++ part, you'll need to setup a cross-compiler. This sucks. But, it
  I did setup a custom Buildroot OS for this and now I get super fast boot times, and
  can easily build for this target.