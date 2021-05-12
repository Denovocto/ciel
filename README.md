# Ciel
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
![GitHub Workflow Status](https://img.shields.io/github/workflow/status/Denovocto/Ciel/CI)
![GitHub deployments](https://img.shields.io/github/deployments/Denovocto/Ciel/github-pages)


The Ciel programming language keeps programming clean, simple and fun.

# Introduction
The Ciel programming language is a statically typed, generic and structured programming language. The general idea of the language is for it to be fun and simple to program in while still exploring fresh and new concepts. 

The main purpose of this Ciel programming language is to remove all unnecessary complexity and maximize developer efficiency. The language also helps to produce clean and consistent applications which can be easily read and understood, making usability one of it strongest features. Ciel programming language is written using C and C++ as its base.

# Motivation
The main motivation behind the Ciel programming language is to explore interesting ideas and introduce them to the programming community in a fresh and simple manner such that it will prove to be pleasant and intuitive to work on. This is the reason why the Ciel team decided to create a language in which its syntax will be more clear and precise, because it will bring another interesting way of interacting and interfacing with a computer system in a much personalized or stylish way. Therefore, Ciel brings a more comfortable and orderly feel to its users.

# Dependancies
To successfully compile the project, your system will need to have installed:
* make build system
* c++11 compatible compiler
* c99+ compatible compiler
* flex library and toolchain
* bison library and toolchain
# GNU GCC instalation
Before installing the GNU compiler toolchain, you should verify if you already have it installed.
To verify if you have it installed, head to your terminal application of choice and in the shell program,
enter: `gcc --version` & then `g++ --version` this tells you which version you have as well as notifies you if it is already installed.
To install them, you should first check the repositories of your system's package manager to install them. Most common package manager installations can be found below.
* debian-based - `sudo apt-get install -y gcc g++`
* arch-based - `sudo pacman -Syu gcc g++`
* MacOSX = `brew install gcc g++`
# GNU Bison and Flex instalation
To install Bison and Flex is very similar to installing any other package from a package manager, just like described above.
To install them, you should first check the repositories of your system's package manager to install them. Most common package manager installations can be found below.
* debian-based - `sudo apt-get install -y bison flex`
* arch-based - `sudo pacman -Syu bison flex`
* MacOSX = `brew install bison flex`
# Technologies 
* C and C++ programming languages
* Lex/Flex as a scanner generator in C
* Yacc/Bison as a parser generator in C++

# Compiling the language
Before compiling the language you must make sure that your system meets all of the requirements and dependancies.
To use the Ciel language interpreter, you must first compile its executable.
To built the Ciel executable, use make like so:
`make`
# Running the Ciel interpreter
There are two main ways of using the Ciel interpreter.
* Using it interactively
* Using it on a file
## Using the Ciel interpreter interactively
Once, you have compiled the Ciel interpreter successfully, you may run it interactively by just running the executable on its own without passing any arguments to it. Like so: `./ciel`
## Using the Ciel interpreter on a file
To use the Ciel interpreter to interpret a file, you just pass the filename as an argument to the Ciel executable. Like so:
`./ciel <filename>`
# Example Code
You can check out an example of a simple Hello World program written in Ciel language here: 
[Example Program](https://github.com/Denovocto/Ciel/blob/master/example.cl)

# Contributors
* Mariely Ocasio Rodriguez
* Jezreel J. Maldonado Ruiz
