#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
This Resource File sets variables that are used in individual
test cases. It eventually should be replaced with more robust,
less static, variable definitions.
"""

from os import getenv

# General resources
# set friendly_testhostname to 'prod' to run suite against production
# Two fields need to be changed to support running tests in your local development
# environment, first, set friendly_testhostname to localhost, then correct the
# base_url value if you are using a port or key different than 8081 and plosmatch.
'''
friendly_testhostname = 'tahitest'
friendly_testhostname = 'heroku'
if friendly_testhostname == 'prod':
  base_url = ''
elif friendly_testhostname == 'localhost':
  base_url = 'http://localhost:8081/'
else:
  base_url = 'localhost:5000/'
'''

friendly_testhostname = 'https://plos:shrimp@tahi-assess.herokuapp.com/'


# Aperta native registration resources
user_email = 'admin'
user_pw = 'yetishrimp'

user_data = {'admin': {'email': 'shrimp@mailinator.com',
                       'full_name': 'AD Shrimp',
                       'password': 'yetishrimp'}
             }

login_valid_email = 'sealresq+7@gmail.com'
login_invalid_email = 'jgrey@plos.org'
login_valid_uid = 'jgray_sa'
login_invalid_pw = 'in|fury7'
login_valid_pw = 'in|fury8'

au_login = {'user': 'jgray_author',
            'name': ''}
co_login = {'user': 'jgray_collab',
            'name': 'Jeffrey Collaborator',
            'password': login_invalid_pw}  # collaborator login
rv_login = {'user': 'jgray_reviewer',
            'name': 'Jeffrey RV Gray'}  # reviewer login
ae_login = {'user': 'jgray_assocedit'}  # associate editor login mm permissions
he_login = {'user': 'jgray_editor',
            'name': 'Jeffrey AMM Gray',
            'email': 'sealresq+4@gmail.com'}  # handling editor login amm permissions
fm_login = {'user': 'jgray_flowmgr'}   # flow manager permissions
oa_login = {'user': 'jgray_oa'}        # ordinary admin login
sa_login = {'user': 'jgray_sa'}        # super admin login

# Accounts for CAS permissions scheme
creator_login1 = {'user': 'aauthor1', 'name': 'atest author1', 'email': 'sealresq+1000@gmail.com'}
creator_login2 = {'user': 'aauthor2', 'name': 'atest author2', 'email': 'sealresq+1001@gmail.com'}
creator_login3 = {'user': 'aauthor3', 'name': 'atest author3', 'email': 'sealresq+1002@gmail.com'}
creator_login4 = {'user': 'aauthor4', 'name': 'atest author4', 'email': 'sealresq+1003@gmail.com'}
creator_login5 = {'user': 'aauthor5', 'name': 'atest author5', 'email': 'sealresq+1004@gmail.com'}
creator_login6 = {'user': 'aauthor6', 'name': 'atest author6', 'email': 'sealresq+1014@gmail.com'}
creator_login7 = {'user': 'aauthor7', 'name': 'atest author7', 'email': 'sealresq+1015@gmail.com'}
creator_login8 = {'user': 'aauthor8', 'name': 'atest author8', 'email': 'sealresq+1016@gmail.com'}
creator_login9 = {'user': 'aauthor9', 'name': 'atest author9', 'email': 'sealresq+1017@gmail.com'}
creator_login10 = {'user': u'hgrœnßmøñé',
                   'name': u'Hęrmänn. Grœnßmøñé',
                   'email': 'sealresq+1018@gmail.com'}
creator_login11 = {'user': 'aauthor11',
                   'name': 'atest author11',
                   'email': 'sealresq+1019@gmail.com'}
creator_login12 = {'user': u'æöxfjørd', 'name': u'Ænid Öxfjørd', 'email': 'sealresq+1020@gmail.com'}
creator_login13 = {'user': 'aauthor13',
                   'name': 'atest author13',
                   'email': 'sealresq+1021@gmail.com'}
creator_login14 = {'user': 'aauthor14',
                   'name': 'atest author14',
                   'email': 'sealresq+1022@gmail.com'}
creator_login15 = {'user': 'aauthor15',
                   'name': 'atest author15',
                   'email': 'sealresq+1023@gmail.com'}
creator_login16 = {'user': 'aauthor16860',
                   'name': 'atest author16',
                   'email': 'sealresq+1024@gmail.com'}
creator_login17 = {'user': 'aauthor17',
                   'name': 'atest author17',
                   'email': 'sealresq+1025@gmail.com'}
creator_login18 = {'user': 'aauthor18',
                   'name': 'atest author18',
                   'email': 'sealresq+1026@gmail.com'}
creator_login19 = {'user': 'aauthor19',
                   'name': 'atest author19',
                   'email': 'sealresq+1027@gmail.com'}
creator_login20 = {'user': 'aauthor20',
                   'name': 'atest author20',
                   'email': 'sealresq+1028@gmail.com'}
creator_login21 = {'user': 'aauthor21',
                   'name': 'atest author21',
                   'email': 'sealresq+1029@gmail.com'}
creator_login22 = {'user': 'aauthor22',
                   'name': 'atest author22',
                   'email': 'sealresq+1030@gmail.com'}
creator_login23 = {'user': u'민성', 'name': u'성민준', 'email': 'sealresq+1031@gmail.com'}
creator_login24 = {'user': u'志張', 'name': u'志明 張', 'email': 'sealresq+1032@gmail.com'}
creator_login25 = {'user': u'文孙', 'name': u'文 孙', 'email': 'sealresq+1033@gmail.com'}

reviewer_login = {'user': 'areviewer',
                  'name': 'atest reviewer',
                  'email': 'sealresq+1005@gmail.com'}
staff_admin_login = {'user': 'astaffadmin',
                     'name': 'atest staffadmin',
                     'email': 'sealresq+1006@gmail.com'}
handling_editor_login = {'user': 'ahandedit',
                         'name': 'atest handedit',
                         'email': 'sealresq+1007@gmail.com'}
pub_svcs_login = {'user': 'apubsvcs',
                  'name': 'atest pubsvcs',
                  'email': 'sealresq+1008@gmail.com'}
academic_editor_login = {'user': 'aacadedit',
                         'name': 'atest acadedit',
                         'email': 'sealresq+1009@gmail.com'}
internal_editor_login = {'user': 'aintedit',
                         'name': 'atest intedit',
                         'email': 'sealresq+1010@gmail.com'}
super_admin_login = {'user': 'asuperadm',
                     'name': 'atest superadm',
                     'email': 'sealresq+1011@gmail.com'}
cover_editor_login = {'user': 'acoveredit',
                      'name': 'atest coveredit',
                      'email': 'sealresq+1012@gmail.com'}
prod_staff_login = {'user': 'aprodstaff',
                    'name': 'atest prodstaff',
                    'email': 'sealresq+1013@gmail.com'}
billing_staff_login = {'user': 'abillstaff',
                       'name': 'atest billstaff',
                       'email': 'sealresq+1034@gmail.com'}
# anyone can be a discussion_participant
# everyone has a user role for their own profile page

# User groupings, users are authors, collaborators, discussion participants, etc.
users = [creator_login1,
         creator_login2,
         creator_login3,
         creator_login4,
         creator_login5,
         creator_login6,
         creator_login7,
         creator_login8,
         creator_login9,
         creator_login10,
         creator_login11,
         creator_login12,
         creator_login13,
         creator_login14,
         creator_login15,
         creator_login16,
         creator_login17,
         creator_login18,
         creator_login19,
         creator_login20,
         creator_login21,
         creator_login22,
         creator_login23,
         creator_login24,
         creator_login25,
         ]

editorial_users = [internal_editor_login,
                   staff_admin_login,
                   super_admin_login,
                   prod_staff_login,
                   pub_svcs_login,
                   ]

external_editorial_users = [cover_editor_login,
                            handling_editor_login,
                            academic_editor_login,
                            ]

admin_users = [staff_admin_login,
               super_admin_login,
               ]

# Define connector information for Aperta's Tahi component postgres instance
# NOTA BENE: Production data should NEVER be included in this file.
# DEV/CI
psql_hname = getenv('APERTA_PSQL_HOST', 'db-aperta-201.sfo.plos.org')
# QA/RC
# psql_hname = getenv('APERTA_PSQL_HOST', 'db-aperta-301.sfo.plos.org')
# Stage
# psql_hname = getenv('APERTA_PSQL_HOST', 'db-aperta-401.sfo.plos.org')
# Global
psql_port = getenv('APERTA_PSQL_PORT', '5432')
psql_uname = getenv('APERTA_PSQL_USER', 'tahi')
psql_pw = getenv('APERTA_PSQL_PW', '')
psql_db = getenv('APERTA_PSQL_DBNAME', 'tahi')

editor_name_0 = 'Hendrik W. van Veen'
user_email_0 = 'trash87567@ariessc.com'
editor_name_1 = 'Anthony George'
user_email_1 = 'trash261121@ariessc.com'
user_pw_editor = 'test_password'

# Fake affiliations
affiliation = {'institution': 'Universidad Del Este',
               'title': 'Dr.',
               'country': 'Argentina',
               'start': '12/01/2014',
               'end': '08/11/2015',
               'email': 'test@test.org',
               'department': 'Molecular Biology',
               'initials': 'JMD',
               'government': False}

# Author for Author card
author = {'first': 'Jane',
          'middle': 'M',
          'last': 'Doe',
          'initials': 'JMD',
          'title': 'Dr.',
          'email': 'test@test.org',
          'department': 'Molecular Biology',
          '1_institution': 'Universidad Del Este',
          '2_institution': 'Universidad Nacional del Sur'}

group_author = {'group_name': 'Rebel Alliance',
                'group_inits': 'RA',
                'first': 'Jackson',
                'middle': 'V',
                'last': 'Stoeffer',
                'email': 'test@test.org'}

billing_data = {'first': 'Jane',
                'last': 'Doe',
                'title': 'Dr.',
                'email': 'test@test.org',
                'department': 'Molecular Biology',
                'affiliation': 'Universidad Del Este',
                '2_institution': 'Universidad Nacional del Sur',
                'address1': 'Codoba 2231',
                'phone': '123-4567-8900',
                'city': 'Azul',
                'state': 'CABA',
                'ZIP': '12345',
                'country': 'Argentina'}

# Generally, a random choice is made from among these documents when we create a new manuscript in
#   the test suite.
docs = ['ANATOMICAL_BRAIN_IMAGES_ALONE_CAN_ACCURATELY_DIAGNOSE_NEUROPSYCHIATRIC_ILLNESSES.docx',
        'A_Division_in_PIN-Mediated_Auxin_Patterning_During_Organ_Initiation_in_Grasses.docx',
        'A_Novel_Alpha_Kinase_EhAK1_Phosphorylates_Actin_and_Regulates_Phagocytosis_in_.docx',
        'A_Systematic_Review_and_Meta-analysis_of_the_Efficacy_and_Safety_of_Intermittent_.doc',
        'A_laboratory_critical_incident_and_error_reporting_system_for_experimental_.docx',
        'A_reappraisal_of_how_to_build_modular_reusable_models_of_biological_systems.doc',
        'A_unified_framework_for_partitioning_biological_diversity.docx',
        'Abby_normal_Contextual_Modulation.docx',
        'Abnormal_Contextual_Modulation_of_Visual_Contour_Detection_in_Patients_with_.docx',
        'Abundance_of_commercially_important_reef_fish_indicates_different_levels_of_.docx',
        'Actin_turnover_in_lamellipodial_fragments.DOCX',
        'Acupuncture_and_Counselling_for_Depression_in_Primary_Care_a_Randomised_Controlled.docx',
        'Adaptation_to_Temporally_Fluctuating_Environments_by_the_Evolution_of_Maternal_.docx',
        'Aedes_hensilli_as_a_Potential_Vector_of_Chikungunya_and_Zika_Viruses.doc',
        'Alternative_Immunomodulatory_Strategies_for_Xenotransplantation_CD80_CD86-CTLA4_.doc',
        'An_In-Depth_Analysis_of_a_Piece_of_Shit_Distribution_of_Schistosoma_mansoni_and_.doc',
        'Antibiotic_prescription_for_COPD_exacerbations_admitted_to_hospital_European_COPD_.docx',
        'Association_of_Medical_Students_Reports_of_Interactions_with_the_Pharmaceutical_and_.docx',
        'Benefit_from_B-lymphocyte_Depletion_using_the_Anti-CD20_Antibody_Rituximab_in_Chronic.doc',
        'Beyond_the_Whole-Genome_Duplication_Phylogenetic_Evidence_for_an_Ancient_.docx',
        'Blue_Marble_Health_A_Call_for_Papers.docx',
        'Budding_Yeast_a_Simple_Model_for_Complex_Traits.docx',
        'Caloric_Restriction_Regulates_Stem_Cell_Homeostasis_Promoting_Enhanced_.docx',
        'Chemical_Synthesis_of_Bacteriophage_G4.doc',
        'Chikungunya_Disease_Infection-Associated_Markers_from_the_Acute_to_the_Chronic_Phase_.doc',
        'Chromosome_X-wide_association_study_identifies_loci_for_fasting_insulin_and_height_.docx',
        'Clinical_trial_data_open_for_all_A_regulators_view.doc',
        'Cognitive_Impairment_Induced_by_Delta9-tetrahydrocannabinol_Occurs_through_.docx',
        'Correction_Macrophage_Control_of_Phagocytosed_Mycobacteria_Is_Increased_by_Factors_.docx',
        'Cytoplasmic_Viruses_Rage_Against_the_Cellular_RNA_Decay_Machine.docx',
        'DNA_Fragments_Assembly_Based_on_Nicking_Enzyme_System.docx',
        'Demographic_transition_and_the_dynamics_of_measles_in_China.docx',
        'Diet_shifts_provoke_complex_and_variable_changes_in_the_metabolic_networks_of_the_.docx',
        'Dietary_non-esterified_oleic_acid_decreases_the_jejunal_levels_of_anorectic_.docx',
        'Discovery_of_covalent_ligands_via_non-covalent_docking_by_dissecting_covalent_.docx',
        'Does_conflict_of_interest_disclosure_worsen_bias.doc',
        'Dynamic_Modulation_of_Mycobacterium_tuberculosis_Regulatory_Networks_During_.doc',
        'Effect_of_Heterogeneous_Investments_on_the_Evolution_of_Cooperation_in_Spatial_.docx',
        'Epidermal_Growth_Factor_Receptor-dependent_Mutual_Amplification_between_Netrin-1_.docx',
        'Evidence_of_a_bacterial_receptor_for_lysozyme_Binding_of_lysozyme_to_the_anti-σ_.docx',
        'Expanding_the_diversity_of_mycobacteriophages_Insights_into_genome_architecture_and_.docx',
        'Externally_Safe_Test.docx',
        'Fecal_contamination_of_drinking-water_in_low_and_middle-income_countries_a_.docx',
        'Fitness_costs_of_noise_in_biochemical_reaction_networks_and_the_evolutionary_limits_.docx',
        'Fitness_costs_of_noise_in_biochemical_reaction_networks_and_the_evolutionary_edited.docx',
        'Gene_expression_signature_predicts_human_islet_integrity_and_transplant_.docx',
        'Genetic_testing_for_TMEM154_mutations_associated_with_lentivirus_susceptibility_in.docx',
        'Genome-wide_diversity_in_the_Levant_reveals_recent_structuring_by_culture.doc',
        'Here_is_a_test_paper_with_some_Caption-styled_text.docx',
        'High_Reinfection_Rate_after_Preventive_Chemotherapy_for_Fishborne_Zoonotic_.doc',
        'HomeRun_Vector_Assembly_System_A_Flexible_and_Standardized_Cloning_System_for_.docx',
        'Honing_the_Priorities_and_Making_the_Investment_Case_for_Global_Health.docx',
        'HowOpenIsIt_Open_Access_Spectrum_FAQ.docx',
        'Human_Parvovirus_B19_Induced_Apoptotic_Bodies_Contain_Self-Altered_Antigens_that_.docx',
        'Human_Parvovirus_B19_Induced_Apoptotic_Bodies_Contain_Self-Altered_Antigens_edited.docx',
        'Identification_of_a_Major_Phosphopeptide_in_Human_Tristetraprolin_by_Phosphopeptide_.docx',
        'Impairment_of_TrkB-PSD-95_signaling_in_Angelman_Syndrome.doc',
        'Improved_glomerular_filtration_rate_estimation_by_artificial_neural_network.doc',
        'Interplay_between_BRCA1_and_RHAMM_Regulates_Epithelial_Apicobasal_Polarization_and_.doc',
        'Life_Expectancies_of_South_African_Adults_Starting_Antiretroviral_Treatment_.doc',
        'Mentalizing_Deficits_Constrain_Belief_in_a_Personal_God.docx',
        'Microbial_Hub_Taxa_Link_Host_and_Abiotic_Factors_to_Plant_Microbiome_Variation.docx',
        'Modifier_genes_and_the_plasticity_of_genetic_networks_in_mice.doc',
        'Modulation_of_Cortical_Oscillations_by_Low-Frequency_Direct_Cortical_Stimulation_is_.docx',
        'Multidrug-resistant_tuberculosis_treatment_regimens_and_patient_outcomes.doc',
        'Musical_Training_Modulates_Listening_Strategies_Evidence_for_Action-based_.docx',
        'NTDs_V.2.0_Blue_Marble_Health-Neglected_Tropical_Disease_Control_and_Elimination_in_.docx',
        'Neonatal_mortality_rates_for_193_countries_in_2009_with_trends_since_1990_progress_.doc',
        'Neural_phase_locking_predicts_BOLD_response_in_human_auditory_cortex.docx',
        'New_material_of_Beelzebufo_a_hyperossified-frog_Amphibia_Anura_from_the_Late-.docx',
        'OVARIAN_CANCER_AND_BODY_SIZE.doc',
        'Parallel_evolution_of_HIV-1_in_a_long-term_experiment.docx',
        'Parallel_evolution_of_HIV-1_in_a_long-term_experiment–with_caption_style_removed.docx',
        'Polymorphisms_in_genes_involved_in_the_NF-ĸB_signalling_pathway_are_associated_with_.docx',
        'Potential_role_of_M._tuberculosis_specific_IFN-γ_and_IL-2_ELISPOT_assays_in_.doc',
        'Preclinical_Applications_of_3-Deoxy-3-18F_Fluorothymidine_in_Oncology–A_Systematic_.docx',
        'Probing_the_anti-obesity_effect_of_grape_seed_extracts_reveals_that_purified_.docx',
        'Promoter_sequence_determines_the_relationship_between_expression_level_and_noise.doc',
        'Protonic_Faraday_cage_effect_of_cell_envelopes_protects_microorganisms_from_.docx',
        'Rare_species_support_semi-vulnerable_functions_in_high-diversity_ecosystems.docx',
        'Rare_species_support_semi-vulnerable_functions_in_high-diversity_ecosystems_edited.docx',
        'Reduction_of_the_Cholesterol_Sensor_SCAP_in_the_Brains_of_Mice_Causes_Impaired_.doc',
        'Relative_impact_of_multimorbid_chronic_conditions_on_health-related_quality_of_life–.doc',
        'Remotely_sensed_high-resolution_global_cloud_dynamics_for_predicting_ecosystem_and_.docx',
        'Research_Chimpanzees_May_Get_a_Break.doc',
        'Retraction_Polymorphism_of_9p21.3_Locus_Associated_with_5-Year_Survival_in_High-.docx',
        'Retraction_Polymorphism_of_9p21.3_Locus_Associated_with_5-Year_Survival_in_edited.docx',
        'Rnf165_Ark2C_Enhances_BMP-Smad_Signaling_to_Mediate_Motor_Axon_Extension.docx',
        'Schmallenberg_Virus_Pathogenesis_Tropism_and_Interaction_With_the_Innate_Immune_.doc',
        'Scientific_Prescription_to_Avoid_Dangerous_Climate_Change_to_Protect_Young_People_.docx',
        'Serological_Evidence_of_Ebola_Virus_Infection_in_Indonesian_Orangutans.doc',
        'Sex-stratified_genome-wide_association_studies_including_270000_individuals_show_.docx',
        'Sliding_rocks_on_Racetrack_Playa_Death_Valley_National_Park_first_observation_of_.docx',
        'Social_network_analysis_shows_direct_evidence_for_social_transmission_of_tool_use_.docx',
        'Standardized_Assessment_of_Biodiversity_Trends_in_Tropical_Forest_Protected_Areas_.docx',
        'Stat_and_Erk_signalling_superimpose_on_a_GTPase_network_to_promote_dynamic_Escort_.docx',
        'Structural_Basis_for_the_Recognition_of_Human_Cytomegalovirus_Glycoprotein_B_by_a_.docx',
        'Structural_mechanism_of_ER_retrieval_of_MHC_class_I_by_cowpox.docx',
        'Synergistic_Parasite-Pathogen_Interactions_Mediated_by_Host_Immunity_Can_Drive_the_.doc',
        'TOLL-LIKE_RECEPTOR_8_AGONIST_AND_BACTERIA_TRIGGER_POTENT_ACTIVATION_OF_INNATE_.docx',
        'Test_Manuscript_for_Disappearing_Figure_Legends.docx',
        'The_Circadian_Clock_Coordinates_Ribosome_Biogenesis_R2.doc',
        'The_Circadian_Clock_Coordinates_Ribosome_Biogenesis_R5.docx',
        'The_Epidermal_Growth_Factor_Receptor_Critically_Regulates_Endometrial_Function_.docx',
        'The_Impact_of_Psychological_Stress_on_Mens_Judgements_of_Female_Body_Size.docx',
        'The_Relationship_between_Leukocyte_Mitochondrial_DNA_Copy_Number_and_Telomere_Length_.doc',
        'The_earliest_evolutionary_stages_of_mitochondrial_adaptation_to_low_oxygen.docx',
        'The_eyes_dont_have_it_Lie_detection_and_Neuro-Linguistic_Programming.doc',
        'The_internal_organization_of_the_mycobacterial_partition_assembly_does_the_DNA_wrap_.docx',
        'The_natural_antimicrobial_carvacrol_inhibits_quorum_sensing_in_Chromobacterium_.docx',
        'Thresher_Sharks_Use_Tail-Slaps_as_a_Hunting_Strategy.docx',
        'Twelve_years_of_rabies_surveillance_in_Sri_Lanka_1999–2010.doc',
        'Ubiquitin-mediated_response_to_microsporidia_and_virus_infection_in-C._elegans.docx',
        'Uncovering_Treatment_Burden_As_A_Key_Concept_For_Stroke_Care_A_Systematic_Review_of_.docx',
        'Vaccinia_Virus_Protein_C6_is_a_Virulence_Factor_that_Binds_TBK-1_Adaptor_Proteins_.doc',
        'Why_Do_Cuckolded_Males_Provide_Paternal_Care.docx'
        ]

# Generally, a random choice is made from among these figures when we create a new figure in
#   the test suite.
figures = ['FIg1_2B_281_29.eps',
           'FIgure_1.tif',
           'Fig 1.tif',
           'Fig 2.tif',
           'Fig 3.tif',
           'Fig 4.tif',
           'Fig 5.tif',
           'Fig 6.tif',
           'Fig 7.tif',
           'Fig S1.tif',
           'Fig S10.tif',
           'Fig S11.tif',
           'Fig S12.tif',
           'Fig S13.1.tif',
           'Fig S14.tif',
           'Fig S15.tif',
           'Fig S16.tif',
           'Fig S17.tif',
           'Fig S18.tif',
           'Fig S2.tif',
           'Fig S3.tif',
           'Fig S4.tif',
           'Fig S5.tif',
           'Fig S6.tif',
           'Fig S7.tif',
           'Fig S8.tif',
           'Fig S9.tif',
           'Fig1 2.tif',
           'Fig1 3.tif',
           'Fig1 4.tif',
           'Fig1 5.tif',
           'Fig1 6.tif',
           'Fig1 7.tif',
           'Fig1.tif',
           'Fig2 2.tif',
           'Fig2 copy.tif',
           'Fig2.tif',
           'Fig2_2B_282_29.eps',
           'Fig3 2.tif',
           'Fig3.tif',
           'Fig3_2B_282_29.eps',
           'Fig4 2.tif',
           'Fig4 copy.tif',
           'Fig4.tif',
           'Fig5.tif',
           'Figure 1 PLoS.tif',
           'Figure 1.tiff',
           'Figure 1_updated.tif',
           'Figure 2 PLoS.tiff',
           'Figure 2.revised.tiff',
           'Figure 3 PLoS.tif',
           'Figure 3.tiff',
           'Figure 4.tiff',
           'Figure 5.tiff',
           'Figure S1.tiff',
           'Figure S2.tiff',
           'Figure S3.tiff',
           'Figure S4.tiff',
           'Figure S5.tiff',
           'Figure_2.tif',
           'Figure_3.tif',
           'Figure_4.tif',
           'Figure_5.tif',
           'Figure_6.tif',
           'Figure_7.tif',
           'Figure_S1.tif',
           'Figure_S2.tif',
           'Figure_S3.tif',
           'Figure_S4.tif',
           'HIV testing_journal.pmed.1001874.g003.tiff',
           'Kelly_Figure 10_23-02-13.tif',
           'Kelly_Figure 11_23-02-13.tif',
           'Kelly_Figure 12_23-02-13.tif',
           'Kelly_Figure 1_22-01-13.tif',
           'Kelly_Figure 2_22-02-13.tif',
           'Kelly_Figure 3_22-02-13.tif',
           'Kelly_Figure 4_22-02-13.tif',
           'Kelly_Figure 5_22-02-13.tif',
           'Kelly_Figure 6_22-02-13.tif',
           'Kelly_Figure 7_23-02-13.tif',
           'Kelly_Figure 8_23-02-132.tif',
           'Kelly_Figure 9_23-02-13.tif',
           'Kelly_Figure S1_23-02-13.tif',
           'Kelly_Figure S2_23-02-13.tif',
           'Kelly_Figure S3_23-02-13.tif',
           'Kelly_Figure S4_25-02-13.tif',
           'Kelly_Figure S5_23-02-13.tif',
           'Kelly_Figure S6_23-02-13.tif',
           'Kelly_Figure S7_23-02-13.tif',
           'Kelly_Figure S8_23-02-13.tif',
           'S2_Fig.tif',
           'S3_Fig.tif',
           'S5_Fig.tif',
           'S6_Fig.tif',
           'S7_Fig.tif',
           'S8_Fig.tif',
           'StrikingImage_Seasonality.tif',
           'Strikingimage.tiff',
           'ant foraging_journal.pcbi.1002670.g003.tiff',
           'ardea_herodias_lzw_sm.tiff',
           'ardea_herodias_lzw.tiff',
           'are_you_edible_packbits.tiff',
           'cameroon_journal.pntd.0004001.g009.tiff',
           'dengue virus_journal.ppat.1002631.g001.tiff',
           'fig1.eps',
           'fig2.eps',
           'fig3.eps',
           'fig4.eps',
           'fig5.eps',
           'fig6.eps',
           'figS1.eps',
           'figS10.eps',
           'figS11.eps',
           'figS2.eps',
           'figS3.eps',
           'figS4.eps',
           'figS5.eps',
           'figS6.eps',
           'figS7.eps',
           'figS8.tiff',
           'figS9.eps',
           'figure1_tiff_lzw.tiff',
           'figure1_tiff_nocompress.tiff',
           'figure1_tiff_packbits.tiff',
           'figure1eps.eps',
           'figure2_tiff_lzw.tiff',
           'figure2_tiff_nocompress.tiff',
           'figure2_tiff_packbits.tiff',
           'figure2eps.eps',
           'figure3_tiff_lzw.tiff',
           'figure3_tiff_nocompress.tiff',
           'figure3_tiff_packbits.tiff',
           'figure3eps.eps',
           'fur_elise_nocompress.tiff',
           'genetics_journal.pgen.1003059.g001.tiff',
           'ion selectivity_journal.pbio.1002238.g005.tiff',
           'jag_rtha_lzw.tiff',
           'jag_rtha_nocompress.tiff',
           'jag_rtha_packbits.tiff',
           'killer whale vocalisations_journal.pone.0136535.g001.tiff',
           'monkey brain_journal.pbio.1002245.g003.tiff',
           'monkey.eps',
           'monkey_lzw_compress.tiff',
           'monkey_nocompress.tiff',
           'monkey_packbits_compress.tiff',
           'p10x.tif',
           'p11x.tif',
           'p1x.tif',
           'p2x.tif',
           'p3x.tif',
           'p4x.tif',
           'p5x.tif',
           'p6x.tif',
           'p7x.tif',
           'p8x.tif',
           'p9x.tif',
           'production performance.tiff',
           'reggie-watts_15057274790_o.tif',
           'snakebite_journal.pntd.0002302.g001.tiff',
           'stripedshorecrab.eps',
           'wild rhinos_journal.pone.0136643.g001.tiff',
           ]

# Note that this usage of task names doesn't differentiate between presentations as tasks, in the
#   accordion, and as cards, on the workflow page. This label is being used generically here.
task_names = ['Ad-hoc',
              'Additional Information',
              'Assign Admin',
              'Assign Team',
              'Authors',
              'Billing',
              'Competing Interests',
              'Cover Letter',
              'Data Availability',
              'Editor Discussion',
              'Ethics Statement',
              'Figures',
              'Final Tech Check',
              'Financial Disclosure',
              'Front Matter Reviewer Report',
              'Initial Decision',
              'Initial Tech Check',
              'Invite Academic Editor',
              'Invite Reviewers',
              'New Taxon',
              'Production Metadata',
              'Register Decision',
              'Related Articles',
              'Reporting Guidelines',
              'Reviewer Candidates',
              'Revision Tech Check',
              'Send to Apex',
              'Supporting Info',
              'Title And Abstract',
              'Upload Manuscript']

# The developer test journal PLOS Yeti contains a custom set of task names
yeti_task_names = ['Ad-hoc',
                   'Additional Information',
                   'Assign Admin',
                   'Assign Team',
                   'Authors',
                   'Billing',
                   'Competing Interests',
                   'Cover Letter',
                   'Data Availability',
                   'Editor Discussion',
                   'Ethics Statement',
                   'Figures',
                   'Final Tech Check',
                   'Financial Disclosure',
                   'Front Matter Reviewer Report',
                   'Initial Decision',
                   'Initial Tech Check',
                   'Invite Academic Editor',
                   'Invite Reviewers',
                   'New Taxon',
                   'Production Metadata',
                   'Register Decision',
                   'Related Articles',
                   'Reporting Guidelines',
                   'Reviewer Candidates',
                   'Revision Tech Check',
                   'Send to Apex',
                   'Supporting Info',
                   'Test Task',
                   'Title And Abstract',
                   'Upload Manuscript']

# This is a list of valid paper tracker queries from which one is chosen during the test of that
#   feature.
paper_tracker_search_queries = ['1000003',
                                'Genome',
                                'DOI IS pwom',
                                'TYPE IS research',
                                'DECISION IS major revision',
                                'STATUS IS submitted',
                                'TITLE IS genome',
                                'STATUS IS rejected OR STATUS IS withdrawn',
                                '(TYPE IS NoCards OR TYPE IS OnlyInitialDecisionCard) AND '
                                '(STATUS IS rejected OR STATUS IS withdrawn)',
                                'STATUS IS NOT unsubmitted',
                                'USER aacadedit HAS ROLE academic editor',
                                'USER ahandedit HAS ANY ROLE',
                                'ANYONE HAS ROLE cover editor',
                                'USER aacadedit HAS ROLE academic editor AND STATUS IS submitted',
                                'USER areviewer HAS ROLE reviewer AND NO ONE HAS ROLE academic '
                                'editor',
                                'NO ONE HAS ROLE cover editor',
                                'VERSION DATE > 3 DAYS AGO',
                                'SUBMISSION DATE < 2 DAYS AGO',
                                'SUBMISSION DATE = 2016/10/13',
                                'VERSION DATE > 10/01/2016',
                                'SUMBISSION DATE = 09/2016',
                                'SUBMISSION DATE > last Friday',
                                'SUBMISSION DATE > November, 2015',
                                'USER me HAS ANY ROLE',
                                'TASK invite reviewers HAS OPEN INVITATIONS',
                                'ALL REVIEWS COMPLETE',
                                'NOT ALL REVIEWS COMPLETE',
                                ]

# The following MMT definitions are seed data for our integration test suite
only_init_dec_mmt = {'name'              : 'OnlyInitialDecisionCard',
                     'user_tasks'        : ['Initial Decision', 'Upload Manuscript'],
                     'staff_tasks'       : ['Assign Team', 'Editor Discussion', 'Final Tech Check',
                                            'Initial Tech Check', 'Invite Academic Editor',
                                            'Invite Reviewers', 'Register Decision',
                                            'Related Articles',
                                            'Revision Tech Check', 'Send to Apex',
                                            'Title And Abstract'],
                     'uses_resrev_report': True
                     }
only_rev_cands_mmt = {'name'              : 'OnlyReviewerCandidates',
                      'user_tasks'        : ['Reviewer Candidates', 'Upload Manuscript'],
                      'staff_tasks'       : ['Assign Team', 'Editor Discussion', 'Final Tech Check',
                                             'Initial Tech Check', 'Invite Academic Editor',
                                             'Invite Reviewers', 'Production Metadata',
                                             'Register Decision', 'Related Articles',
                                             'Revision Tech Check', 'Send to Apex',
                                             'Title And Abstract'],
                      'uses_resrev_report': True
                      }
front_matter_mmt = {'name'              : 'Front-Matter-type',
                    'user_tasks'        : ['Additional Information', 'Authors', 'Figures',
                                           'Supporting Info', 'Upload Manuscript'],
                    'staff_tasks'       : ['Invite Reviewers', 'Production Metadata',
                                           'Register Decision', 'Related Articles', 'Send to Apex',
                                           'Title And Abstract'],
                    'uses_resrev_report': False
                    }
research_mmt = {'name'              : 'Research',
                'user_tasks'        : ['Authors', 'Billing', 'Cover Letter', 'Figures',
                                       'Financial Disclosure', 'Supporting Info',
                                       'Upload Manuscript'],
                'staff_tasks'       : ['Assign Admin', 'Invite Academic Editor',
                                       'Invite Reviewers', 'Register Decision',
                                       'Title And Abstract'],
                'uses_resrev_report': True
                }
resrch_w_init_dec = {'name'              : 'Research w/Initial Decision Card',
                     'user_tasks'        : ['Authors', 'Billing', 'Cover Letter', 'Figures',
                                            'Financial Disclosure', 'Supporting Info',
                                            'Upload Manuscript'],
                     'staff_tasks'       : ['Assign Admin', 'Initial Decision',
                                            'Invite Academic Editor', 'Invite Reviewers',
                                            'Register Decision', 'Title And Abstract'],
                     'uses_resrev_report': True
                     }
imgs_init_dec_mmt = {'name'              : 'Images+InitialDecision',
                     'user_tasks'        : ['Figures', 'Initial Decision', 'Upload Manuscript'],
                     'staff_tasks'       : ['Assign Team', 'Editor Discussion', 'Final Tech Check',
                                            'Invite Academic Editor', 'Invite Reviewers',
                                            'Production Metadata', 'Register Decision',
                                            'Related Articles', 'Revision Tech Check',
                                            'Send to Apex',
                                            'Title And Abstract'],
                     'uses_resrev_report': True
                     }
gen_cmplt_apexdata = {'name'              : 'generateCompleteApexData',
                      'user_tasks'        : ['Additional Information', 'Authors', 'Billing',
                                             'Competing Interests', 'Cover Letter',
                                             'Data Availability', 'Ethics Statement', 'Figures',
                                             'Financial Disclosure', 'New Taxon',
                                             'Reporting Guidelines', 'Reviewer Candidates',
                                             'Supporting Info', 'Upload Manuscript'],
                      'staff_tasks'       : ['Assign Team', 'Editor Discussion', 'Final Tech Check',
                                             'Invite Academic Editor', 'Invite Reviewers',
                                             'Production Metadata', 'Register Decision',
                                             'Related Articles', 'Revision Tech Check',
                                             'Send to Apex',
                                             'Title And Abstract'],
                      'uses_resrev_report': True
                      }
no_cards_mmt = {'name'              : 'NoCards',
                'user_tasks'        : ['Upload Manuscript'],
                'staff_tasks'       : ['Assign Team', 'Editor Discussion', 'Final Tech Check',
                                       'Invite Academic Editor', 'Invite Reviewers',
                                       'Production Metadata', 'Register Decision',
                                       'Related Articles', 'Revision Tech Check', 'Send to Apex',
                                       'Title And Abstract'],
                'uses_resrev_report': True
                }
