# Evaluating Precision Attacks for Data Privacy Systems 

## Status 

    - Available
    - Level: master thesis 

## Company 

[DPella AB](www.dpella.io) is a deep tech startup that has developed a solution
to do privacy preserving analytics using Differential Privacy (DP) technology
(see below). DPella’s team of world experts (all with PhDs) in DP technology and
in building privacy-by-design and secure-by-design systems believe that this
technology is the best existing approach for doing privacy preserving analytics.  
This thesis will be carried out at DPella AB offices, Kungsgatan 11 - 6th floor,
41119 Gothenburg.

- DPella AB supervisor: Marco Gaboardi
- Chalmers supervisor: Prof. Alejandro Russo
- Possible examiner: Prof. David Sands

## Skills required to complete the thesis:
- A good level of math 
- Knowledge about Haskell programming language

## Proposal 

[Differential privacy](https://link.springer.com/chapter/10.1007/11681878_14)
(DP) is emerging as a viable solution to release statistical information about
the population without compromising data subjects' privacy. A standard way to
achieve DP is by adding some statistical noise to the result of a data analysis.
If the noise is carefully calibrated, it provides *privacy* protection for the
individuals contributing their data. A standard way to achieve DP is adding some
carefully calibrated noise to the result of a query.

In 2022, there has been discovered 
[an attack to Differential Privacy systems using floating point numbers](https://arxiv.org/abs/2207.13793). The attack allows to determine the real answer of boolean queries protected by a Differential Privacy mechanism. To understand the attack, 
we need to observations about the representation of floating point numbers as well as some properties they have. 

### Representation 

According to the IEEE standard, a double precision representation consists of three parts: *sign*, *biased exponent*, and *normalized mantissa*:

1. **Sign**: If the sign bit is 0, the number is positive. If it is 1, the number is negative.
2. **Biased exponent**: Subtract the bias from the biased exponent to get the actual exponent. The bias for double-precision floating-point numbers is 1023.
3. **Mantissa**: Add an implicit leading 1 to the left of the binary point of the normalized mantissa.
4. **Combine**: The value of the floating-point number is given by `(-1)^sign * 2^(exponent) * mantissa`.

For example, let's take the double-precision floating-point representation

```
Sign: 0
Biased Exponent: 10000000101
Normalized Mantissa: 101010010000000000000000000000000000000000000000000
```
1. The sign bit is 0, so the number is positive.
2. The biased exponent is `10000000101` in binary, which is `1029` in decimal. Subtracting the bias of `1023`, we get an actual exponent of `6`.
3. The normalized mantissa is `010101001000...`, so we add an implicit leading 1 to get `1.010101001`.
4. The value of the floating-point number is `(-1)^0 * 2^6 * 1.010101001`. The binary number `1.010101001` can be converted to a decimal number by summing the values of the powers of two corresponding to each 1 digit. This gives us `1 * 2^0 + 0 * 2^(-1) + 1 * 2^(-2) + 0 * 2^(-3) + 1 * 2^(-4) + 0 * 2^(-5) + 1 * 2^(-6) + 0 * 2^(-7) + 0 * 2^(-8) + 1 * 2^(-9)`, which is equal `1.330078125`. So, the decimal number is then **`(-1)^0 * 2^6 * 1.330078125 = 85.125`. 

Observe that if you want a certain exponent, e.g., `k`, then the biased exponent
is `k + 1023`. Conversely, if the biased exponent is `e`, then the actual
exponent is `e - 1023`. In other words, to obtain the biased exponent from the
actual exponent, you add the bias of `1023`. To obtain the actual exponent from
the biased exponent, you subtract the bias of `1023`.

Let us rewrite the decimal number $x$ represented by the IEEE double-precision representation. Let's assume that the sign is $s$, the biased exponent is $e$, and the mantissa digits $m_i$. 

$$ x = (-1)^s  2^{e - 1023}  (1 + \sum_{i=1}^{52} m_i 2^{-i} ) $$


### Unit in the last place 

The unit in the last place (ULP) is a measure of the spacing between consecutive
representable floating-point numbers. It represents the difference between a
given floating-point number and the next representable floating-point number in
terms of magnitude, regardless of the sign.

To understand ULP, we should ask ourselves, given a number what is the minimum
distance to the next representable float? Ignoring the sign, and taking the
formula shown above, we can say that the closest representable floating point is
when $m_52$-bit gets set or unset. So, the ULP magnitude is given by the formula 

$$ \mathrm{ulp}(x) = 2^{e - 1023} 2^{-52} = 2^{e - 1023 - 52} $$

Let's rewrite it without the biased exponent, so let's call $p = e - 1023$, so we get that 

$$ \mathrm{ulp}(x) = 2^{\mathrm{p} - 52} $$

With this, we can see that within an exponent, there is a certain level of
spacing. The bigger the exponent $p$, the bigger the spacing. 

### Properties of the representation 

The attack is based on the following properties of the representation. 

**Theorem 1**: For any floating point number $x$ such that $2^{k} \leq |x| < 2^{k+1}$, then $x$ is a multiple of $\mathrm{ulp}(x) = 2^{k-52}$.

**Corollary I**: Given a floating point number $x$, under the conditions of Theorem 1, that is multiple of $\mathrm{ulp}(x)$, then it is also multiple of $\frac{\mathrm{ulp}(x)}{2}$.

**Theorem 2**: Let $x$ and $y$ be two doubles, where $x > 0$, then 
$x + y$ is a multiple of $\frac{\mathrm{ulp}(x)}{2}$.

## Attack 

The attack has as a purpose to distinguish if a counting query returns $0$ or
$1$. This is pretty similar to the goal of other [floating point attacks as
Mironov's](https://www.microsoft.com/en-us/research/wp-content/uploads/2012/10/lsbs.pdf). 

The attack is going to use Theorem 2 at its heart. Let's consider the case when
the counting query $Q$ returns $1$. 

## $Q(D) = 1$

We observe that, taking $k = 0$, we have that $2^{k} \leq |1| < 2^{k+1} = 2^{0}
\leq |1| < 2^{1}$. 

By definition $\mathrm{ulp}{(Q(D))} = 2^{-52}$. So, if we assume some noise $n$
sampled to provide a differentially private count $Q'$: 

$$Q'(D) = 1 + n$$

By Theorem 2 (taking $x = Q(D)$, and $y = n$), we know that $Q'(D)$ is a
multiple of $\frac{\mathrm{ulp}(Q(D))}{2} = 2^{-53}$.

To launch an attack, we need to make sure that, when the true count is $0$, then
the noise answer is **not** a multiple of $2^{-53}$. 

## $Q(D) = 0$

In this case, we have that 

$$ Q'(D) = 0 + n = n$$

So, if we can make $n$ not to be a multiple of $2^{-53}$, we will complete the
attack. The first observation is that $n$ is the noise that we can control with
the privacy parameters given to the Differential Privacy mechanism. 

We observe that, taking $k = -2$, we have that if we can make $n$ such as $2^{k}
\leq |n| < 2^{k+1} = 2^{-2} \leq |n| < 2^{-1}$. Then, by Theorem 1, we know that
$n$ is multiple of $ulp(n) = 2^{k-52} = 2^{-2-52} = 2^{-54}$.

At this point, if the noise is between $2^{-2} \leq |n| < 2^{-1} = \frac{1}{4}
\leq |n| < \frac{1}{2}$, then |n| is not **(place holder)** a multiple of $2^{-53}$! 

However, what does happen if $|n| < 2^{-2}$? Well, let's take $k = -3$, so
that it holds that $2^{-3} \leq |n| < 2^{-2}$. By Theorem 1, we know that
$n$ is multiple of $ulp(n) = 2^{k-52} = 2^{-3-52} = 2^{-55}$. This is not
(**place holder**) either a multiple of $2^{-53}$!. What does it happen if $|n|
< 2^{-3}$? Well, we repeat the reasoning and continue to do so with a noise |n|
that gets smaller and smaller. 

In summary, if $|n| < 2^{-1}$, then $n$ might not be a multiple of
$2^{-53}$.

To sum up, 

* If $Q'(D)$ **is** a multiple of $2^{-53}$, then $Q(D) = 1$. 
* If $Q'(D)$ **is not** (**place holder**) a multiple of $2^{-53}$, then $Q(D) = 0$

## The thesis

The idea of this thesis comes from the fact that, in the text above where it
says **place holder**, it should say **not necessarily** since the way the
attack distinguishes events (i.e., $Q(D)=0$ or $Q(D)=1$) does not always work. 

The goals of this thesis are: 

1. characterizing, and proving, how effective is the attack as presented in the
   original paper. For instance, how well is this attack guessing $0$ and $1$
   with respect to just flipping a fair coin and guessing the answer? 

2. How well the attack scales to counting queries which answers go beyond $1$?
   and how is that related to the magnitude of noise being injected? 

3. An implementation of a test suite (in Haskell) that effectively supports all
   the claims of the thesis. 

