require('flit').setup {
   keys = { f = 'f', F = 'F', t = 't', T = 'T' },
   -- A string like "nv", "nvo", "o", etc.
   multiline = true,
   -- Like `leap`s similar argument (call-specific overrides).
   -- E.g.: opts = { equivalence_classes = {} }
   opts = {},
   labeled_modes = "nx",
}
