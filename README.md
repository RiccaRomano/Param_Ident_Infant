# Practical Parameter Identifiability in the Extremely Preterm Infant
Richard Foster and Laura Ellwein Fix <br>
Department of Mathemtaics and Applied Mathematics <br>
Virginia Commonwealth University <br>
Richmond, VA USA <br>

Abstract:

The complexity of mathematical models describing respiratory mechanics has grown in recent years, however, parameter identifiability of such models has only been studied in the last decade in the context of observable data. This study investigates parameter identifiability of a nonlinear respiratory mechanics model tuned to the physiology of an extremely preterm infant, using global Morris screening, local deterministic sensitivity analysis, and singular value decomposition-based subset selection. The model predicts airflow and dynamic pulmonary volumes and pressures under varying levels of continuous positive airway pressure, and a range of parameters characterizing both surfactant-treated and surfactant-deficient lung. Sensitivity analyses indicated nine parameters influence model outputs over the range of continuous positive airway pressure and lung health scenarios. The model was adapted to data from a spontaneously breathing 1kg infant using gradient-based optimization to estimate the parameter subset characterizing the patient's state of health. 

## Description

This project performs global and local sensitivity analyses, singular-value decomposition and QR-factorization-based subset selection, and gradient-based optimization against reported clinical data for a pulmonary mechanics model of a preterm infant. Below, you should find code and data relating to this project, organized in the following folders:

* Nominal Outputs
* Morris Method
* Local Analysis
* Optimization Abbasi Data
* Reduced Model Outputs

## Getting Started

### Dependencies

Program prerequisites just include MATLAB (newer versions preferred)

### Executing program

Run code in the "Nominal Outputs" folder to obtain initial model outputs before any parameter estimation is performed.


## Help

Any advise for common problems or issues.
```
command to run if program contains helper info
```

## Authors

Laura Ellwein Fix: lellwein@vcu.edu (corresponding author) <br>
Richard Foster: fosterrr@vcu.edu

## Version History

* 0.1
    * Initial Release
