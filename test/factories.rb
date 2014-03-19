FactoryGirl.define do	
	factory :blast_result do |f|
		f.accession "XM_004044273.1"
		f.bitscore 119.0
		f.contig_name "comp0_c0_seq1"
		f.contig_length 185
		f.contig_description "comp0_c0_seq1 len=185 path=[163:0-120 284:121-184]"
		f.file_name "fallon_140748/trinity_non_human_paired.blastn.txt"
		f.gaps "0/64"
		f.gaps_percent 0
		f.identities "64/64"
		f.identities_percent 100
		f.score 64
		f.seq_name "ref|XM_004044273.1| PREDICTED: Gorilla gorilla gori..."
		f.seq_length 1818
		f.strand "Plus/Plus"
		f.expect 9.0e-24
	end
end
__END__

=> #<BlastResult id: 1, file_name: "fallon_140748/trinity_non_human_paired.blastn.txt", contig_name: "comp0_c0_seq1", contig_description: "comp0_c0_seq1 len=185 path=[163:0-120 284:121-184]", contig_length: 185, seq_name: "ref|XM_004044273.1| PREDICTED: Gorilla gorilla gori...", seq_length: 1818, bitscore: 119.0, score: 64, expect: 9.0e-24, identities: "64/64", identities_percent: 100, gaps: "0/64", gaps_percent: 0, strand: "Plus/Plus", accession_prefix: "ref", accession: "XM_004044273.1", hit_order: 1>

