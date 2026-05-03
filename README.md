# 🕸️ Network Science: Wikipedia Voting Network

> A full-stack network science project analysing the **Wikipedia Adminship Voting Network** — covering structural topology, random graph theory, community detection, failure propagation, opinion dynamics, and flow optimisation. Built in Python with NetworkX.

![Python](https://img.shields.io/badge/Python-3.10%2B-blue?logo=python&logoColor=white)
![NetworkX](https://img.shields.io/badge/NetworkX-3.x-orange?logo=python&logoColor=white)
![Jupyter](https://img.shields.io/badge/Jupyter-Notebook-F37626?logo=jupyter&logoColor=white)
![NumPy](https://img.shields.io/badge/NumPy-1.26%2B-013243?logo=numpy)
![SciPy](https://img.shields.io/badge/SciPy-1.11%2B-8CAAE6?logo=scipy&logoColor=white)
![Matplotlib](https://img.shields.io/badge/Matplotlib-3.8%2B-11557C)
![License](https://img.shields.io/badge/License-MIT-green)

---

## 📌 Overview

This project applies theoretical and computational network science techniques to a real-world directed graph: the [Stanford SNAP Wikipedia Vote Network](https://snap.stanford.edu/data/wiki-Vote.html), where nodes are Wikipedia users and directed edges represent votes cast during adminship elections (7,115 nodes, 103,689 edges).

The notebook is a single end-to-end analysis covering seven interconnected topics:

| Part | Topic | Key Techniques |
|:---:|---|---|
| 1 | **Structural Analysis** | SCC/WCC decomposition, degree distributions, power-law fitting, centrality measures |
| 2 | **Random Graph Phase Transitions** | G(N,p) and G(N,L) Erdős–Rényi models, percolation threshold, bootstrapped error bars |
| 3 | **Biased Random Walk Sampling** | Eigenvector-centrality-weighted subgraph extraction |
| 4 | **Community Detection** | Girvan-Newman algorithm, modularity curve, assortativity comparison |
| 5 | **Failure Propagation** | Cascade avalanche model, critical φ_c via peak susceptibility |
| 6 | **Opinion Dynamics** | 3-opinion voter model, disagreement evolution |
| 7 | **Flow Optimisation** | Min-cost max-flow (Network Simplex), budget-constrained demand maximisation |

---

## 📊 Key Results

| Analysis | Finding |
|---|---|
| **Network size** | 7,115 nodes · 103,689 directed edges |
| **Giant SCC** | 1,300 nodes (18.3% of network) — reflects rare mutual voting |
| **Giant WCC** | 7,066 nodes (99.3% of network) — near-fully connected community |
| **Degree distribution** | Scale-free: in-degree γ ≈ −1.8, max in-degree = 1,165 |
| **Phase transition** | GCC emerges sharply at ⟨k⟩ = 1 (Erdős–Rényi theory confirmed) |
| **G(N,p) vs G(N,L)** | Same critical point; G(N,L) shows lower variance (fixed edge count) |
| **Community detection** | 10-community Girvan-Newman partition; best modularity at coarser resolution |
| **Failure propagation** | Critical threshold φ_c identified via variance peak (susceptibility) |
| **Max-flow** | Maximum deliverable demand within budget=100 found via Network Simplex |

---

## 🗂️ Repository Structure

```
network-science-portfolio/
│
├── network_science_portfolio.ipynb   # Main notebook — all 7 analyses
├── README.md                         # This file
├── setup.sh                          # One-command environment setup
├── push_to_github.sh                 # Automated GitHub push script
│
├── data/
│   └── wikivote.txt                  # ⬇ Download separately (see Setup)
│
└── figures/                          # Auto-generated when notebook runs
    ├── fig1_degree_distributions.png
    ├── fig2_centrality_comparison.png
    ├── fig3a_gnp_transition.png
    ├── fig3b_gnp_vs_gnl.png
    ├── fig4_disconnected_network.png
    ├── fig5_subnetwork.png
    ├── fig6_community_detection.png
    ├── fig7_failure_propagation.png
    ├── fig8_voter_model.png
    └── fig9_min_cost_flow.png
```

---

## 🚀 Quick Start

### 1 · Clone the repository

```bash
git clone https://github.com/YOUR_USERNAME/network-science-portfolio.git
cd network-science-portfolio
```

### 2 · Install dependencies

```bash
pip install networkx numpy matplotlib scipy jupyter
```

Or with conda:

```bash
conda install networkx numpy matplotlib scipy jupyter -c conda-forge
```

### 3 · Download the dataset

The Wikipedia Vote Network is available from Stanford SNAP:

```bash
mkdir -p data
curl -o data/wikivote.txt.gz https://snap.stanford.edu/data/wiki-Vote.txt.gz
gunzip data/wikivote.txt.gz
```

> The dataset file must be named `wikivote.txt` and placed in the `data/` folder, **or** in the same directory as the notebook. The notebook loads it with `nx.read_edgelist("wikivote.txt", ...)`.

### 4 · Run the notebook

```bash
jupyter notebook network_science_portfolio.ipynb
```

Run all cells top to bottom (`Kernel → Restart & Run All`). Figures are automatically saved to the working directory.

---

## 🔬 Analysis Walkthrough

### Part 1 — Structural Analysis

The network is loaded as a `nx.DiGraph`. Strongly and weakly connected components are extracted and their size distributions reported. Three degree distributions (in, out, total) are plotted on log-log axes with power-law fits computed via SciPy linear regression on the log-log scale.

Four centrality measures are computed on the giant SCC:
- **Eigenvector centrality** — influence weighted by neighbour influence  
- **PageRank** (α=0.85) — recursive vote prestige  
- **Betweenness centrality** (normalised) — bridge/broker role  
- **Closeness centrality** — global reachability efficiency

### Part 2 — Phase Transitions

The Erdős–Rényi percolation threshold ⟨k⟩ = 1 is reproduced numerically by sweeping average degree and averaging the giant component fraction over 200 independent realisations per point. Error bars are ±2 SEM (≈95% CI on the mean). The same experiment is repeated for G(N,L) and both curves overlaid.

### Part 3 — Biased Random Walk

A centrality-biased walk samples 100 nodes from the giant WCC. At each step, the walker moves to a neighbour with probability proportional to that neighbour's eigenvector centrality — over-sampling the hub region relative to a uniform walk. Centrality distributions of the subgraph vs. the full WCC are compared.

### Part 4 — Girvan-Newman Community Detection

Edges are removed iteratively by betweenness centrality. We extract the 10-community partition and track modularity Q across all splits to find the natural resolution of the network. Assortativity coefficients compare the two partitions.

### Part 5 — Failure Propagation

A cascade model sweeps φ ∈ [0, 1] with 500 trials per value. The critical threshold φ_c is identified as the peak of the variance curve — the analogue of susceptibility divergence in statistical physics. Average avalanche size shows the corresponding sharp transition from localised to network-wide cascades.

### Part 6 — 3-Opinion Voter Model

The binary voter model is extended to 3 opinions. Nodes update asynchronously: one node per timestep adopts an opinion with probability equal to its neighbours' opinion frequency. Simulated on G(500, 0.55) for 500 timesteps.

### Part 7 — Min-Cost Max-Flow

A connected directed G(10, 40) graph is generated with random integer capacities and costs ∈ [5, 10]. Source and target are chosen as the maximally distant node pair (undirected BFS). Demand is incremented from 1 until total flow cost exceeds a budget of 100; NetworkX's `min_cost_flow` (Network Simplex) solves each instance.

---

## 🛠️ Tech Stack

| Library | Version | Purpose |
|---|---|---|
| `networkx` | 3.x | Graph algorithms, centrality, community detection, flow |
| `numpy` | 1.26+ | Numerical computing, `default_rng` seeded randomness |
| `matplotlib` | 3.8+ | All visualisations (log-log, error bars, network layouts) |
| `scipy` | 1.11+ | Power-law fitting via `stats.linregress` on log-log scale |
| `collections.Counter` | stdlib | Degree and component size frequency distributions |
| `itertools.islice` | stdlib | Controlled Girvan-Newman iteration |

---

## 🔑 Design Decisions & Improvements

Several improvements were made over a naive implementation:

- **`np.random.default_rng(SEED)`** instead of `np.random.seed()` — the modern NumPy Generator API avoids global state conflicts between cells and library calls.
- **±2 SEM error bars** instead of raw standard deviation — SEM is the correct quantity for confidence intervals on the sample mean; raw std would conflate sampling noise with model uncertainty.
- **Power-law exponent γ** computed via log-log OLS regression (SciPy) and overlaid on degree distribution plots — provides quantitative evidence for scale-free structure rather than visual inspection alone.
- **φ_c detection via `argmax(variance)`** — the variance peak is the correct physics-motivated criterion (peak susceptibility), more robust than gradient-based heuristics on noisy simulation data.
- **Min-cost flow demand signs fixed** — NetworkX's `min_cost_flow` uses the convention that negative demand = supply (source), positive demand = consumption (sink). The original had these reversed.
- **Avalanche subplot bug fixed** — the original accidentally plotted `variances` in both subplots due to a copy-paste error.
- **Flow visualisation** — edge width proportional to flow volume; source/target colour-coded; all edges labelled with capacity and cost.

---

## 📚 References

- Barabási, A.-L. (2016). *Network Science*. Cambridge University Press. [networksciencebook.com](http://networksciencebook.com)
- Leskovec, J., Huttenlocher, D. & Kleinberg, J. (2010). Signed Networks in Social Media. *Proc. CHI 2010*. *(Wikipedia Vote dataset)*
- Girvan, M. & Newman, M.E.J. (2002). Community structure in social and biological networks. *PNAS*, 99(12), 7821–7826.
- Erdős, P. & Rényi, A. (1960). On the evolution of random graphs. *Publ. Math. Inst. Hung. Acad. Sci.*, 5, 17–61.
- Ford, L.R. Jr. & Fulkerson, D.R. (1962). *Flows in Networks*. Princeton University Press.
- NetworkX Developers (2024). *NetworkX Documentation*. [networkx.org](https://networkx.org/documentation/stable/)
- SciPy Community (2024). *SciPy Documentation*. [scipy.org](https://scipy.org)
- OpenAI (2024). ChatGPT (GPT-4). Response to prompt on average distance metrics in disconnected networks. *(Referenced in Part 2, Q2c — per assignment specification)*

---

## 👤 Author

**Abir Alam Srabon**  
BSc/MSc Student — Aston University, Birmingham  
🔗 [LinkedIn]https://www.linkedin.com/in/abir-alam-srabon/ · 

---

*Completed as part of AM41NS Network Science — Aston University, College of Engineering & Physical Sciences.*
