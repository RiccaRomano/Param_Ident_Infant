# Practical Parameter Identifiability in the Extremely Preterm Infant
Richard Foster and Laura Ellwein Fix <br>
Department of Mathemtaics and Applied Mathematics <br>
Virginia Commonwealth University <br>
Richmond, VA USA <br>

Abstract:

The complexity of mathematical models describing respiratory mechanics has grown in recent years, however, parameter identifiability of such models has only been studied in the last decade in the context of observable data. This study investigates parameter identifiability of a nonlinear respiratory mechanics model tuned to the physiology of an extremely preterm infant, using global Morris screening, local deterministic sensitivity analysis, and singular value decomposition-based subset selection. The model predicts airflow and dynamic pulmonary volumes and pressures under varying levels of continuous positive airway pressure, and a range of parameters characterizing both surfactant-treated and surfactant-deficient lung. Sensitivity analyses indicated nine parameters influence model outputs over the range of continuous positive airway pressure and lung health scenarios. The model was adapted to data from a spontaneously breathing 1kg infant using gradient-based optimization to estimate the parameter subset characterizing the patient's state of health. 

## Description

This project performs global and local sensitivity analyses, singular-value decomposition and QR-factorization-based subset selection, and gradient-based optimization against reported clinical data for a pulmonary mechanics model of a preterm infant. The available code only runs the nominal outputs of the model under various lung health scenarios and CPAP administration levels. Any other code related to the project can be obtained by contacting the authors at the email address

## Getting Started

The code driver is appropriately named driver.m. This script will call all other associated files to solve a system of ODEs and calculate time-varying constitutive relations in model compartments. Order of function call goes as follows:

driver -> load_pars -> model_sol -> test_curves_preterm -> Model <br>

load_pars.m appropriately loads parameter values, initial conditions, and parameter names of the system. <br>
model_sol.m runs an ODE solver to obtain time-varying state tracings and corresponding constitutive relation solutions. <br>
test_curves_preterm.m constructs lung/alveolar and chest wall compliance relations and uses a nonlienar solver to find functional residual capacity (FRC) and associated lung and chest wall pressures at FRC. <br>
Model.m contains all state and constitutive relations, it is called for every time step of the ODE solver. <br>

### Dependencies

Program prerequisites include MATLAB (newer versions preferred)

Laura Ellwein Fix: lellwein@vcu.edu (corresponding author) <br>
Richard Foster: fosterrr@vcu.edu <br>

## Version History

* 0.1
    * Initial Release
