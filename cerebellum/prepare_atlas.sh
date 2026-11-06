#!/bin/bash

# toto som zmenil oproti povodnemu atlasPack-u, kvoli nc. dentatus 

# Get the atlas description
wget https://github.com/DiedrichsenLab/cerebellar_atlases/raw/master/Diedrichsen_2009/atlas_description.json

# Get the labels (already in TSV!!)
wget https://github.com/DiedrichsenLab/cerebellar_atlases/raw/master/Diedrichsen_2009/atl-Anatom.tsv

# Get the actual atlas
wget https://github.com/DiedrichsenLab/cerebellar_atlases/raw/master/Diedrichsen_2009/atl-Anatom_space-MNI_dseg.nii

# This is in a strange volume, but in coordinate space it's
# "..._space-MNI.nii: volume file aligned to FNIRT MNI space", which is NLin6Asym.

# Resample it into the official TemplateFlow volume
# To NLin6Asym (no transform)
antsApplyTransforms \
    -d 3 \
    -i atl-Anatom_space-MNI_dseg.nii \
    -o tpl-MNI152NLin6Asym_atlas-Anatom_res-01_dseg.nii.gz  \
    -r ${TEMPLATEFLOW_HOME}/tpl-MNI152NLin6Asym/tpl-MNI152NLin6Asym_res-01_desc-brain_mask.nii.gz \
    --interpolation GenericLabel \
    -v 1

# To 2009cAsym
antsApplyTransforms \
    -d 3 \
    -i atl-Anatom_space-MNI_dseg.nii \
    -o tpl-MNI152NLin2009cAsym_atlas-Anatom_res-01_dseg.nii.gz  \
    -t ${TEMPLATEFLOW_HOME}/tpl-MNI152NLin2009cAsym/tpl-MNI152NLin2009cAsym_from-MNI152NLin6Asym_mode-image_xfm.h5 \
    -r ${TEMPLATEFLOW_HOME}/tpl-MNI152NLin2009cAsym/tpl-MNI152NLin2009cAsym_res-01_desc-brain_mask.nii.gz \
    --interpolation GenericLabel \
    -v 1

sed -i '' 's/name/label/' atl-Anatom.tsv
