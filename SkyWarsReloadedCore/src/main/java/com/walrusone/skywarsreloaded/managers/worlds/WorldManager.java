package com.walrusone.skywarsreloaded.managers.worlds;

import org.bukkit.Bukkit;
import org.bukkit.World;

import java.io.File;
import java.util.Locale;

public interface WorldManager {

    World createEmptyWorld(String name, World.Environment environment);

    boolean loadWorld(String worldName, World.Environment environment, boolean readOnly);

    void unloadWorld(String world, boolean save);

    void copyWorld(File source, File target);

    /**
     *
     * @param name Name of the world to remove
     * @param removeFile Only applies to {@link ASWMWorldManager#deleteWorld(String, boolean)}, whether to delete the world folder.
     */
    void deleteWorld(String name, boolean removeFile);

    void deleteWorld(File file);

    WorldManagerType getType();

    /**
     * The folder the server keeps a world's files in. Paper 26 keeps every world as a dimension of the main level
     * ({@code world/dimensions/minecraft/<name>}), older servers in the world container.
     *
     * @param name Name of the world
     */
    default File getWorldFolder(String name) {
        if (!Bukkit.getWorlds().isEmpty()) {
            File dimensions = Bukkit.getWorlds().get(0).getWorldFolder().getParentFile();
            if (dimensions != null && dimensions.getParentFile() != null && dimensions.getParentFile().getName().equals("dimensions")) {
                return new File(dimensions, name.toLowerCase(Locale.ROOT));
            }
        }
        return new File(Bukkit.getWorldContainer().getAbsolutePath(), name);
    }

}
