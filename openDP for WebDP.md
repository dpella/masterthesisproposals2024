# A general purpose API for [OpenDP](https://opendp.org/)

## Status 

    - Available
    - Level: bachelor thesis 

## Company 

[DPella AB](www.dpella.io) is a deep tech startup that has developed a solution
to do privacy preserving analytics using Differential Privacy (DP) technology
(see below). DPella’s team of world experts (all with PhDs) in DP technology and
in building privacy-by-design and secure-by-design systems believe that this
technology is the best existing approach for doing privacy preserving analytics.  

- DPella AB supervisor: Prof. Marco Gaboardi
- Chalmers supervisor: Prof. Alejandro Russo
- Possible examiner: Prof. David Sands

## Skills required to complete the thesis:

- Rust 
- Some knowledge about open APIs
- Python 

## Proposal 

[Differential privacy](https://link.springer.com/chapter/10.1007/11681878_14)
(DP) is emerging as a viable solution to release statistical information about
the population without compromising data subjects' privacy. A standard way to
achieve DP is by adding some statistical noise to the result of a data analysis.
If the noise is carefully calibrated, it provides *privacy* protection for the
individuals contributing their data. Nowadays, there is a lack of standards for
DP,  implementing DP is very challenging for people with no expertise in the
technology. The spread of this technology worldwide faces a high entry barrier
despite the availability of open source libraries implementing it.  

In the end of 2023, [DPella](https://www.dpella.io) has been developing a open
API called *WebDP* that enables the exchange of data insights while preserving
privacy. WebDP is engine-agnostic, meaning that common Differential Privacy
concepts map transparently across DP implementations. This will help to
encourage adoption and reduce migration costs between tools, making Differential
Privacy an accessible and affordable solution for businesses and individuals of
all sizes. By fostering standardization activities, DPella will promote a
culture of privacy and security that will benefit everyone. 

The project consists on creating a WebDP connector to WebDP. That is

- You will need to connect the different end-points of the WebDP API to OpenDP,
  which is program in Rust. 
- As a more academic question, the project should evaluate and suggest
  modification to the WebDP API based on how well it fits OpenDP. 

## What would you learn by doing this project? 

- State of the art concepts and tools for data privacy (that is capture by WebDP
  API)
- Access to world-leader researchers in data privacy to discuss about your
  design.
