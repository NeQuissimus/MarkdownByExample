# GoodTool Scala API

---

# Get statistics

    !scala
    // This is what the GoodTool API could report
    object GoodToolStats {
        var stats: Map[String, Int] = Map("latency" -> 3, "load" -> 12)
    }

    // This is how to use the API
    object Stats {
        val stats = GoodToolStats.stats
    }

    Stats.stats should equal (Map("latency" -> 3, "load" -> 12))

---

# Check the API documentation for more information!
