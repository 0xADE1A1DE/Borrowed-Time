# Borrowed Time
_~2 minute read_

An in-chip countermeasure against static side-channel analysis attacks, built for deployment in FPGAs. 

### Basic principles of use and security relevance
Static side-channel analysis exploits leakage of circuit state elements while their stored values are not changing. Typically, inducing such a state requires stopping the circuit input clock. Our countermeasure serves to monitor the clock signal and upon detecting a stop condition, immediately wipe sensitive register contents in a secure manner. 

## Paper report
These designs are artefacts of research that has been published in a paper titled _On Borrowed Time – Preventing Static Side-Channel Analysis_, to appear in [NDSS '25](https://www.ndss-symposium.org/ndss2025/). Preprint available online [here](https://github.com/0xADE1A1DE/Borrowed-Time/...) or [arXiv]([https://arxiv.org/abs/2211.01109](https://arxiv.org/abs/2307.09001)).

## Protected targets
This repo contains design files for two cryptographic systems that are implemented directly in hardware, each of which is equipped with the Borrowed Time countermeasure.
Each instance is designed for implementation on a specific target IC since the countermeasure operates based on the physical properties of the underlying technology.

- `AES128` - no other side-channel analysis countermeasures - deployment on Xilinx Kintex-7 (XC7K160T-1FBG676C)
- `SKINNY-128-128` - first-order masking protection - deployment on Xilinx Spartan-6 (XC6SLX75-2CSG484C)

Porting these designs to other targets requires some additional engineering, namely to ensure the delay-chain circuits are correctly tuned. See paper for more information. 

## Author of original cores
These applications are based on open third-party cryptographic cores:
`AES` core based on _sasebo_giii_aes_ core found [here](https://satoh.cs.uec.ac.jp/SAKURA/hardware/SAKURA-X.html)
`SKINNY` core based on _MSKSkinny_encrypt_ core found [here](https://github.com/uclcrypto/aead_modes_leveled_hw)

## Copyright and license
Original source:
- (`AES` core) Copyright (C) 2012, 2013 AIST
- (`SKINNY` core) Copyright Corentin Verhamme and UCLouvain, 2022

Modified source - Copyright 2024 by [Robbie Dumitru](https://robbiedumitru.github.io/), Ruhr University Bochum, and The University of Adelaide, 2024

These applications can be freely modified, used, and distributed as long as the attributions to both the original author and author of modifications (and their employers) are not removed.

## Acknowledgements
#### This project was supported by:  
* an ARC Discovery Early Career Researcher Award number DE200101577
* an ARC Discovery Project number DP210102670
* the Defence Science and Technology Group (DSTG), Australia under Agreement ID10620
* the Deutsche Forschungsgemeinschaft (DFG, German Research Foundation) under Germany's Excellence Strategy - EXC 2092 CASA - 390781972
