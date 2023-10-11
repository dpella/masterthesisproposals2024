---
colorlinks: true
---


# FrontDP: A Privacy-Aware Front-end for WebDP 

## Status 

    - Available
    - Level: bachelor thesis 
    - Target group of students: DV, D, and IT

## Company 

[DPella AB](www.dpella.io) is a deep tech startup that has developed a solution
to do privacy preserving analytics using Differential Privacy (DP) technology
(see below). DPella’s team of world experts (all with PhDs) in DP technology and
in building privacy-by-design and secure-by-design systems believe that this
technology is the best existing approach for doing privacy preserving analytics.  

- DPella AB supervisor: Carola Compá 
- Chalmers supervisor: Prof. Alejandro Russo
- Possible examiner: Prof. David Sands


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

The project consists on creating a user friendly front-end for the different
aspects of WebDP. From a global point of view, the front-end should be able to: 

1. Perform user authentication 
2. Support different functionalities based on different user roles: 
    - Data curator: it enforces a global privacy level for analytics obtained
      from a given dataset. 
    - Data analysts: it specifies analytics to be performed with a certian
      privacy protection level. 
3. Definition and upload of datasets 
4. Plot / export results

At DPella, we follow strict coding practices to ensure the security and privacy
of all the information being handled. In that light, we propose to develop the
front-end or extend existing ones (see below) by 

- using [Typescript](https://www.typescriptlang.org/) to avoid simple errors. Nevertheless, we could explore how the types in typescript can be used to enforce invariants of the API. 
- following [privacy-by-design principles](https://en.wikipedia.org/wiki/Privacy_by_design). 

## Related work 

A good starting point to have an idea about the direction of this project is to
take a look (and use) the system [PSI ($\Psi$): a Private data Sharing
Interface](https://privacytools.seas.harvard.edu/psi-%CF%88-private-data-sharing-interface). 

There exists an open source front-end graphical interface for an specific DP
system called [DP Creator](https://github.com/opendp/dpcreator). One starting
point for the project is to study and extend such framework to work with WebDP.
This will also imply to contribute to the OpenDP project, which will increase
visibility to this work in the data privacy space. 


## What would you learn by doing this project? 

- State of the art concepts and tools for data privacy
- Possibility to learn cutting-edge tools to develop secure software
- Access to world-leader researchers in data privacy to discuss about your
  design.

