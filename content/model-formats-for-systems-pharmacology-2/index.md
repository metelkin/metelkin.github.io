---
layout: post.njk
title: 'Model Formats in Systems Pharmacology. Part 2'
subtitle: 'Engineering Practices We Can Borrow'
date: 2025-09-05
lastModified: 2025-09-01
description: 'An overview of how model formats shape QSP modeling—its challenges, tools, and why engineering practices are key for progress.'
author: Evgeny Metelkin
authorURL: https://metelkin.me
canonical: https://metelkin.me/model-formats-for-systems-pharmacology-2
openGraph:
    title: 'Model Formats in Systems Pharmacology. Part 2: Engineering Practices We Can Borrow'
    description: 'An overview of how model formats shape QSP modeling—its challenges, tools, and why engineering practices are key for progress.'
    url: https://metelkin.me/model-formats-for-systems-pharmacology-2
    image: https://metelkin.me/model-formats-for-systems-pharmacology-2/img/fig0-cover.jpg
    site_name: Evgeny Metelkin
    type: article
tags: 
    - SoftwareEngineering
    - modeling
    - datascience
    - pharma
    - biology

---

![Cover](./img/fig0-cover.jpg)

_**DRAFT**_

_In [Part 1](/model-formats-for-systems-pharmacology-1), we looked at the landscape of QSP model formats—their origins, strengths, and limitations. We saw how tools approach modeling in different ways, yet still leave teams struggling with Locked-in projects, fragile reproducibility, and poor collaboration. In this follow-up, I want to step back and explore the problem from a software engineering perspective: what practices and design principles could make QSP modeling more transparent, modular, and reproducible, and how model formats can evolve to support that shift._

## 5. Modeling as code

In software, the “X as code” idea has proven itself many times over—**Infrastructure as Code** ([Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/infrastructure-as-code)), **Configuration as Code** ([Ansible](https://www.redhat.com/en/blog/ansible-automation-platform-2.3-configuration-as-code-improvements)), and **Pipeline as Code** ([Jenkins](https://www.jenkins.io/doc/book/pipeline/jenkinsfile/)), among others. The core idea is simple: we don’t just manage **artifacts** (infrastructure, configuration, pipelines) directly—we manage their **textual representation** under version control, even if those artifacts were never treated as “code” before. In all cases, the **authoritative source** is human-readable text. This doesn’t exclude working with diagrams or tables—authoring can stay visual or interactive, but the canonical format must still be code. This shift brought massive gains in transparency, modularity, and reproducibility, and accelerated progress in software engineering.
The question is: can we do the same in QSP?

If we look back at the popular formats discussed earlier, not all of them can be considered model as code. Some are well-suited; others are not. QSP formats that are locked in binary or tool-specific project files cannot be diffed, reviewed, split, or merged—and therefore cannot be treated as code. Formats that are formally “text-based” but too complex or unstructured for a human to read or write also only partially fit this concept.

Checklist: how to tell if your model is really “as code”
- [ ] Every part of the model can be expressed as text (DSL/JSON/YAML).
- [ ] When a file changes, you can see and understand the difference (diffs) both technically and semantically.
- [ ] You can run simulations, checks, or analyses from the command line or scripts (not only from a GUI).
- [ ] Supporting assets (datasets, scenarios, metadata) are stored alongside the model and easily linked.

When this principle is in place, modelers gain access to an entire ecosystem of tools: version control, diff and merge utilities, code completion, automated testing, and CI/CD pipelines. Nothing needs to be reinvented—these are the same practices that software engineers already use. It means versioned, testable, modular, and reusable models.

In practice, a model becomes more than a loose collection of files: it turns into a full engineering project with a clear folder structure, documentation, and automation. This approach improves reproducibility, makes validation and review more systematic, and simplifies onboarding new team members.

### Code Transparency

**Code transparency** means that every aspect of a model is visible, reviewable, and understandable at a glance. This covers not only the model structure, but also the equations, parameters, and the assumptions embedded within it. A transparent format allows collaborators (and even regulators) to see what exactly the model does without needing the original author or a proprietary tool to “explain” it.

A second requirement is traceable change. Transparency is not only about being able to read the code, but also about being able to see what changed and why between versions. With text-based formats, differences are captured by standard tools (e.g., git diff), making version control, peer review, and collaboration far more effective. Binary or opaque formats cannot provide this—they hide changes inside unreadable blobs.

![Fig](./img/fig1-NONMEM.jpg)
_Fig. 1. Traceable change for NONMEM file. Change is traceable but not easy readable._

A desirable (not strictly mandatory) requirement is self-explanatory code. This means that the model description carries enough context—through clear naming, annotations, and units—that a new reader can understand the intent without constantly referring back to external notes or publications. While not every project achieves this ideal, self-describing code lowers the entry barrier for new collaborators, reduces misinterpretation, and makes the model more resilient to staff turnover or long gaps between updates.

![Fig](./img/fig2-antimony.jpg)
_Fig. 2. Self-explanatory code traceable change. Easy to understand at a glance._

By contrast, QSP environments that store models in binary, closed, or otherwise non-readable formats cannot ensure transparency. They block the very practices—review, versioning, collaboration—that modern scientific software relies on. Even when dedicated comparison tools exist, they are typically ad-hoc, tied to a single platform, and rarely integrate smoothly into a team’s normal project workflow. As a result, they are used sporadically and do not replace true text-level transparency.

![Fig](./img/fig3-simbio.jpg)
_Fig. 3. Non traceable change for Simbiology project. Just files nothing more._

### Modularity

**Modularity** is the ability to divide a project into independent parts that can be developed, tested, and reused separately. It comes from having clear interfaces and well-defined dependencies between components.

Here we use the term broadly: it includes both the **separation of different project layers**—model, data, scripts (covered in more detail in the Separation of Concerns section)—and the internal modularization of the model itself into subcomponents that are easier to manage and understand.

What modularity brings:

- **Simpler development.** Team members can focus on specific components without risking the stability of the whole project; even incomplete models can be useful for parallel work (e.g., visualization, analysis).
- **Code reuse.** Modules can be packaged and reused across projects or systems, avoiding copy-paste and enabling larger blocks to become shared dependencies.
- **Clarity and maintainability.** Smaller, self-contained pieces are easier to read, document, and hand over to new collaborators.
- **Scalability.** Adding a new drug, pathway, or dataset means extending the project with a module rather than rewriting existing code.
- **Experimentation and flexibility.** Alternative implementations (e.g., two different PK models) can be swapped or compared without touching the rest of the system.
- **Collaboration and review.** Clear module boundaries allow parallel work, streamlined peer review, and even regulatory validation on a per-module basis.

A natural way to bring this modularity into practice is through a **clear and consistent project structure**. When each component has its own dedicated place, it becomes easier to navigate, test, and extend the project. In other words, a well-structured repository is the simplest form of modularity:

```
qsp-project/
  model/          # core: states, processes/reactions, equations
  data/           # measurements for calibration/validation (+ units, sources)
  scenarios/      # protocols: simulations, fitting, sensitivity
  docs/           # annotations, assumptions, limitations, references
  pipelines/      # CLI scripts and CI/CD recipes (build, test, report)
  julia/          # Julia code for simulation and analysis
  R/              # R code for simulation and analysis
  project.yml    # project metadata, dependencies, configuration
```

This kind of layout turns a QSP model into something that looks and behaves like any other modern software project: modular, reviewable, and reproducible.

### Longevity

**Longevity** means that a model remains usable and trustworthy years after it was first created. Instead of “remembering which buttons we clicked,” the project can be rebuilt, rerun, and revalidated from its source.

What makes longevity possible:

- **Version history.** With Git or similar systems, projects can be saved as a sequence of working snapshots. Each commit captures the state of parameters, equations, and scenarios at a given moment, creating a project timeline that can be revisited or rolled back when needed.
- **Environment capture.** Pinned dependencies and solver settings (e.g., Project.toml, requirements.txt, renv.lock) ensure the same model can be executed in the future, regardless of local updates.
- **Readable formats.** Text-based models outlive specific tools; even if a GUI disappears, the core code can still be read, parsed, and converted.
- **Re-validation.** As new data or regulatory requirements arise, archived models can be rerun and checked against updated knowledge.
- **Knowledge preservation.** Annotations, comments, and documentation carry context, so understanding does not depend on the original author’s memory.
- **Regulatory and audit needs.** Long-term reproducibility is critical for submissions: teams must show exactly what model was used to support a decision at a given time.

Longevity turns a QSP model from a one-off experiment into a sustainable scientific asset—something that can be reliably shared, revisited, and built upon.

### Automation

**Automation** means that models are executed and tested through scripts instead of manual clicks. Once a model is code, it can be integrated into pipelines that ensure consistent, repeatable runs for simulations, parameter estimation, or sensitivity analyses.

With CI/CD, every commit can automatically launch validation tasks, generate reports, or even dispatch heavy computations to a more powerful server or cluster. This reduces human error, scales effortlessly, and makes QSP projects more reliable and collaborative.

## 6. Separation of Concerns

## 7. Standardization of Formats

## 8. Where to Go Next
