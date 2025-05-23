using Profile

@testset "test ccd probabilities with two trees and four taxa" begin
    newicks = ["((A:1,B:1):1,(C:1,D:1):1):1;", "(A:1,(B:1,(C:1,D:1):1));"]
    trees = load_trees_from_newick(newicks)

    ccd = CCD1(trees)

    @test isapprox(log_density(ccd, trees[1]), log(0.5))
    @test isapprox(log_density(ccd, trees[2]), log(0.5))
end

@testset "test ccd probabilities with three trees and five taxa" begin
    newicks = [
        "(((A, B), C), (D, E));",
        "(((A, B), C), (D, E));",
        "(((A, B), C), (D, E));",
        "(((A, (B, C)), D), E);",
        "(((A, (B, C)), D), E);",
        "(((A, (B, C)), E), D);",
        "(((A, (B, C)), E), D);",
    ]
    trees = load_trees_from_newick(newicks)

    ccd = CCD1(trees)

    @test isapprox(log_density(ccd, Split(Clade(1:2, 5), Clade(3, 5))), log(3 / 7))
    @test isapprox(log_density(ccd, Split(Clade(1, 5), Clade(2:3, 5))), log(4 / 7))

    @test isapprox(log_density(ccd, Split(Clade(1:3, 5), Clade(4:5, 5))), log(3 / 7))
    @test isapprox(log_density(ccd, Split(Clade(1:4, 5), Clade(5, 5))), log(2 / 7))
    @test isapprox(log_density(ccd, Split(Clade([1, 2, 3, 5], 5), Clade(4, 5))), log(2 / 7))

    @test isapprox(log_density(ccd, trees[1]), log(9 / 49))
    @test isapprox(log_density(ccd, trees[4]), log(8 / 49))
    @test isapprox(log_density(ccd, trees[6]), log(8 / 49))

    other_newicks = ["((A, (B, C)), (D, E));", "((((A, B), C), D), E);", "((((A, B), C), E), D);"]
    other_trees = load_trees_from_newick(other_newicks)

    @test isapprox(log_density(ccd, other_trees[1]), log(12 / 49))
    @test isapprox(log_density(ccd, other_trees[2]), log(6 / 49))
    @test isapprox(log_density(ccd, other_trees[3]), log(6 / 49))
end

@testset "test probabilities on bigger Yule-10 treeset" begin
    reference_trees = load_trees("ref_trees.trees")
    query_trees = load_trees("query_trees.trees")

    ccd = CCD1(reference_trees)

    # compare with values from the CCD java implementation 
    @test isapprox(log_density(ccd, query_trees[1]), -2.450003130511848)
    @test isapprox(log_density(ccd, query_trees[2]), -1.3309686096958018)
    @test isapprox(log_density(ccd, query_trees[3]), -1.3309686096958018)
    @test isapprox(log_density(ccd, query_trees[4]), -2.470057331927599)
    @test isapprox(log_density(ccd, query_trees[5]), -2.0143841426158016)
end
